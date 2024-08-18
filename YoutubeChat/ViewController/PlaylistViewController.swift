//
//  PlaylistViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/3/24.
//

import UIKit

class PlaylistViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var videoNumberLabel: SDGothicLabel!
    @IBOutlet weak var urlTextField: URLInputTextField!
    @IBOutlet weak var playlistTableView: UITableView!
    
    @IBOutlet weak var urlTextFieldHeightConstraint: NSLayoutConstraint!
    
    var yPoint: CGFloat = 0
    var chatRoom: ChatRoomData?
    
    var chatViewModel: ChatViewModel?
    var youtubeViewModel: YoutubeViewModel?
    
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
    }
    
    override func viewWillLayoutSubviews() {
        self.view.frame = CGRectMake(0, yPoint, self.view.bounds.width, self.view.window?.bounds.height ?? self.view.bounds.height - yPoint)
    }
    
    private func configureView(){
        guard let chatRoom = chatRoom else { print("🌀 ChatRoom Data Nil Error") ; return }
        
        titleLabel.setLabel(textColor: .black, fontSize: 18)
        videoNumberLabel.setLabel(textColor: Colors.gray, fontSize: 15)
        
        indicatorView.layer.cornerRadius = self.indicatorView.bounds.height / 2
        
        let nib = UINib(nibName: PlayListTableViewCell.identifier, bundle: nil)
        playlistTableView.register(nib, forCellReuseIdentifier: PlayListTableViewCell.identifier)
        
        playlistTableView.dataSource = self
        playlistTableView.delegate = self
        
        urlTextField.delegate = self
        urlTextField.type = .url
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.topBarView.addGestureRecognizer(panGestureRecognizer)
        
        self.playlistTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:))))
        
        urlTextField.textField.text = "https://www.youtube.com/watch?v=2bLuBCw1zXE"
        
        if chatRoom.isOptionContains(.videoAddDenied) && chatRoom.hostId != MyProfile.id{
            urlTextFieldHeightConstraint.constant = 0
        }
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
                    self.dismiss(animated: false)
                })
            }
        default:
        return
        }
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer){
        self.urlTextField.hideKeyboard()
    }
    
    @objc func receiveData(_ notification: Notification){
        if let data = notification.userInfo?["video"] as? AddVideoResponseData {

            youtubeViewModel?.videoArray = data.videos
            print("⭐️ received : \(data.videos)")
            DispatchQueue.main.async{
                self.playlistTableView.reloadData()
            }
            
        } else {
            print("🌀 decoding error")
        }
    }
}

extension PlaylistViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeViewModel?.videoArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playlistTableView.dequeueReusableCell(withIdentifier: PlayListTableViewCell.identifier, for: indexPath) as? PlayListTableViewCell, let youtubeViewModel = youtubeViewModel else {
            return UITableViewCell() }
        
        cell.setVideo(youtubeViewModel.videoArray[indexPath.item])
        
        return cell
    }
}

extension PlaylistViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 20
        let thumbnailImageViewWidth = self.view.bounds.width * 0.36
        return (thumbnailImageViewWidth * 9) / 16 + spacing
    }
}

extension PlaylistViewController: URLInputTextFieldDelegate{
    func addButtonTapped() {
        if urlTextField.isBlank {
            return
        }
        urlTextField.hideKeyboard()
        guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        let message = Message(chatRoomId: id, senderId: MyProfile.id, messageType: .video, text: urlTextField.text, isRead: true)
        chatViewModel?.sendMessage(message)
    }
}
