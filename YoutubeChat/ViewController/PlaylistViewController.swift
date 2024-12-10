//
//  PlaylistViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/3/24.
//

import UIKit

class PlaylistViewController: BaseViewController{
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var videoNumberLabel: SDGothicLabel!
    @IBOutlet weak var urlTextField: URLInputTextField!
    @IBOutlet weak var playlistTableView: UITableView!
    
    @IBOutlet weak var urlTextFieldHeightConstraint: NSLayoutConstraint!
    
    var viewWidth: CGFloat = .zero
    var yPoint: CGFloat = .zero
    var chatRoom: ChatRoomData?
    
    var chatViewModel: ChatViewModel?
    
    var delegate: ChatViewControllerDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reconnect(_:)), name: .reconnected, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        self.view.frame = CGRectMake(0, yPoint, viewWidth, self.view.window?.bounds.height ?? self.view.bounds.height - yPoint)
    }
    
    private func configureView(){
        guard let chatRoom = chatRoom else { print("🌀 ChatRoom Data Nil Error") ; return }
        
        self.view.backgroundColor = .black
        
        titleLabel.setLabel(textColor: .white, fontSize: 18)
        videoNumberLabel.setLabel(textColor: Colors.gray, fontSize: 15)
        
        indicatorView.layer.cornerRadius = self.indicatorView.bounds.height / 2
        
        let nib = UINib(nibName: PlayListTableViewCell.identifier, bundle: nil)
        playlistTableView.register(nib, forCellReuseIdentifier: PlayListTableViewCell.identifier)
        
        playlistTableView.dataSource = self
        playlistTableView.delegate = self
        playlistTableView.bounces = false
        
        urlTextField.delegate = self
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.topBarView.addGestureRecognizer(panGestureRecognizer)
        
        self.playlistTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:))))
        
        urlTextField.textField.text = ""
        
        if !chatRoom.isOptionContains(.videoAddAllowed) && chatRoom.hostId != MyProfile.id{
            urlTextFieldHeightConstraint.constant = 0
            urlTextField.isHidden = true
        }
        
        self.videoNumberLabel.text = "\(String(describing: YoutubeViewModel.shared.videoArray.count ))"
    }
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        let viewTranslation = sender.translation(in: self.view) // 이동한 위치
        let viewVelocity = sender.velocity(in: self.view) // 이동한 방향
        
        switch sender.state {
        case .began:
            break
        case .changed:
            if viewVelocity.y > 0 {
                UIView.animate(withDuration: 0.15){
                    self.view.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                }
            }
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.2){
                    self.view.transform = .identity
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                }, completion: {_ in
                    self.delegate?.dismiss()
                })
            }
        default:
            return
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.delegate?.dismiss()
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer){
        self.urlTextField.hideKeyboard()
    }
    
    @objc func receiveData(_ notification: Notification){
        DispatchQueue.main.async{
            self.urlTextField.resetText()
            self.urlTextField.buttonEnabledToggle()
        }
        if let data = notification.userInfo?["video"] as? AddVideoResponseData {
            
            YoutubeViewModel.shared.videoArray = data.videos
            print("⭐️ received : \(data.videos)")
            DispatchQueue.main.async{
                self.playlistTableView.reloadData()
                self.videoNumberLabel.text = "\(String(describing: YoutubeViewModel.shared.videoArray.count ))"
            }
            
        } else {
            print("🌀 decoding error")
        }
    }
    
    @objc func reconnect(_ notificaton: Notification){
        delegate?.reconnect()
    }
}

extension PlaylistViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YoutubeViewModel.shared.videoArray.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playlistTableView.dequeueReusableCell(withIdentifier: PlayListTableViewCell.identifier, for: indexPath) as? PlayListTableViewCell else {
            return UITableViewCell() }
        
        cell.setVideo(YoutubeViewModel.shared.videoArray[indexPath.item])
        
        return cell
    }
}

extension PlaylistViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 20
        let thumbnailImageViewWidth = self.view.bounds.width * 0.36
        return (thumbnailImageViewWidth * 9) / 16 + spacing
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let chatRoom = chatRoom, let id = chatRoom.id,
                let videoId = YoutubeViewModel.shared.videoArray[indexPath.item].id
        else { print("🌀 ChatRoom Data Nil Error") ; return nil }
        
        if chatRoom.hostId != MyProfile.id {
            print(chatRoom.hostId, MyProfile.id)
            return nil
        }
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            YoutubeViewModel.shared.videoArray.remove(at: indexPath.item) // 데이터에서 항목 삭제
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Task{
                try await YoutubeViewModel.shared.deleteVideo(id, videoId)
            }
            completion(true)
        }
        
        action.backgroundColor = .black
        action.image = UIImage(named: "delete_icon")?.resizedImage(targetSize: CGSize(width: 20, height: 20))
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension PlaylistViewController: URLInputTextFieldDelegate{
    func addButtonTapped() {
        if urlTextField.isBlank {
            return
        }
        urlTextField.hideKeyboard()
        urlTextField.buttonEnabledToggle()
        guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        let message = Message(chatRoomId: id, senderId: MyProfile.id, messageType: .video, text: urlTextField.text, isRead: true)
        chatViewModel?.sendMessage(message)
    }
}
