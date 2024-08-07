//
//  ChatViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatNameLabel: SDGothicLabel!
    @IBOutlet weak var peopleNumberLabel: SDGothicLabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextView: ChatTextView!
    @IBOutlet weak var youtubeView: YoutubeView!

    @IBOutlet weak var chatTextViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var messageInputViewBottomConstraint: NSLayoutConstraint!
    
    private let messageInputViewBottomMargin: CGFloat = 7
    private var keyboardAnimationDuraion: CGFloat = 0
    
    var enteredWithCode = false
    var count = 0
    
    var chatRoom: ChatRoom?
    
    private let chatViewModel = ChatViewModel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initData()
    }
    
    private func configureView(){
        chatNameLabel.setLabel(textColor: .black, fontSize: 15)
        peopleNumberLabel.setLabel(textColor: Colors.gray, fontSize: 13)
        
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        
        self.chatTextView.delegate = self
                
        self.chatTextViewHeightContraint.constant = self.view.bounds.height * 0.04
        
        chatTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:))))
        
        guard let chatRoom = chatRoom else { return }
        chatNameLabel.text = chatRoom.name
        peopleNumberLabel.text = String(chatRoom.participantIds.count)
    }
    
    private func initData(){
        guard let chatInfo = chatRoom, let id = chatInfo.id else { return }
        if enteredWithCode{ // 참여하기 쪽으로 들어왔을때
            // 서버에서 참여했습니다. 문구 띄워야 함
            let message = Message(chatRoomId: id, senderId: MyProfile.id, messageType: .enter, isRead: true)
            chatViewModel.sendMessage(message)
        } else { // main에서 들어왔을 때
            // 만약 그 전에 안읽은 메세지는 다 읽음 처리로
            chatViewModel.fetchMessage(id)
        }
        
        chatTableView.reloadData()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {


//        let imageName = ["riku", "saku", "rikus", "testImage", "testImage2"]
//        
//        count = count + 1 == imageName.count ? 0 : count + 1
//        addImageData(name: "리코", imgName: imageName[count])
//        
//        chatTableView.reloadData()
//
//        chatTableView.scrollToRow(at: IndexPath(row: self.data.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    @objc func receiveData(_ notification: Notification){
        if let data = notification.userInfo?["chatData"] as? Data{
            do {
                let message = try JSONDecoder().decode(Message.self, from: data)
                chatViewModel.receiveMessage(message)
                 DispatchQueue.main.async {
                     self.chatTableView.reloadData()
                     self.chatTableView.scrollToRow(at: IndexPath(row: self.chatViewModel.messageArray.count - 1, section: 0), at: .bottom, animated: true)
                 }
                
                if message.messageType == .enter || message.messageType == .leave{
                    Task{
                        self.chatRoom = try await chatViewModel.fetchChatRoom(id: message.chatRoomId)
                        DispatchQueue.main.async{
                            self.peopleNumberLabel.text = String(self.chatRoom!.participantIds.count)
                        }
                    }
                }
            } catch {
                print("🌀 JSONDecoding Error: \(error.localizedDescription)")
            }
        }
    }
    
    func addImageData(name:String, imgName: String){

    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            keyboardAnimationDuraion = animationDuration
            let keyboardHeight = keyboardFrame.height - self.view.safeAreaInsets.bottom + messageInputViewBottomMargin
            UIView.animate(withDuration: animationDuration) {
                self.messageInputViewBottomConstraint.constant = keyboardHeight
            }
        }
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer){
        self.chatTextView.hideKeyboard()
        UIView.animate(withDuration: keyboardAnimationDuraion) {
            self.messageInputViewBottomConstraint.constant = self.messageInputViewBottomMargin
        }
    }
}
// MARK: UITableViewDataSource
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewModel.messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatViewModel.messageArray[indexPath.item]
        
        // MARK: 내가 보낸 챗
        if ProfileManager.shared.isMyID(message.senderId){
            switch message.messageType{
            case .text:
                let nib = UINib(nibName: ChatTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier) as? ChatTableViewCell else {
                    return UITableViewCell()
                }

                cell.setText(text: message.text)
                
                return cell
            case .image:fallthrough
            case .video:
                let nib = UINib(nibName: ImageChatTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatTableViewCell.identifier) as? ImageChatTableViewCell else {
                    return UITableViewCell()
                }
                
                let image = UIImage(named: message.image!)!
                cell.setImage(image: image)
                
                return cell
            case .enter:fallthrough
            case .leave:break
            }
        } else { // MARK: 남이 보낸 챗
            switch message.messageType{
            case .text:
                let nib = UINib(nibName: ChatWithProfileTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ChatWithProfileTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatWithProfileTableViewCell.identifier) as? ChatWithProfileTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.setText(text: message.text, profileHidden: chatViewModel.isPrevSender(indexPath.item))
                
                return cell
            case .image:fallthrough
            case .video:
                let nib = UINib(nibName: ImageChatWithProfileTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatWithProfileTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatWithProfileTableViewCell.identifier) as? ImageChatWithProfileTableViewCell else {
                    return UITableViewCell()
                }

                let image = UIImage(named: message.image!)!
                cell.setImage(image: image, profileHidden: chatViewModel.isPrevSender(indexPath.item))
                
                return cell
            case .enter:fallthrough
            case .leave:break
            }
        }
        
        // MARK: 공통 챗 (시스템 챗)
        self.chatTableView.register(SystemChatTableViewCell.self, forCellReuseIdentifier: SystemChatTableViewCell.identifier)
        
        guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: SystemChatTableViewCell.identifier, for: indexPath) as? SystemChatTableViewCell else { return UITableViewCell() }
        
        cell.configureView(message.text)
        
        return cell
    }
}
// MARK: UITableViewDelegate
extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = chatViewModel.messageArray[indexPath.item]
        
        // MARK: 내가 보낸 챗
        if ProfileManager.shared.isMyID(message.senderId){
            switch message.messageType{
            case .text:
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier) as? ChatTableViewCell else {
                    return .zero}
                return cell.estimatedHeight(text: message.text)
            case .image:fallthrough
            case .video:
                let nib = UINib(nibName: ImageChatTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatTableViewCell.identifier) as? ImageChatTableViewCell else {
                    return .zero
                }
                
                let image = UIImage(named: message.image!)!
                return cell.estimatedHeight(image: image)
            case .enter:fallthrough
            case .leave:break
            }
        } else { // MARK: 남이 보낸 챗
            switch message.messageType{
            case .text:
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatWithProfileTableViewCell.identifier) as? ChatWithProfileTableViewCell else {
                    return .zero
                }
                
                return cell.estimatedHeight(text: message.text, profileHidden: chatViewModel.isPrevSender(indexPath.item))
            case .image:fallthrough
            case .video:
                let nib = UINib(nibName: ImageChatWithProfileTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatWithProfileTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatWithProfileTableViewCell.identifier) as? ImageChatWithProfileTableViewCell else {
                    return .zero
                }
                
                let image = UIImage(named: message.image!)!
                return cell.estimatedHeight(image: image, profileHidden: chatViewModel.isPrevSender(indexPath.item))
            case .enter:fallthrough
            case .leave:break
            }
        }
        
        // MARK: 공통 챗 (시스템 챗)
        guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: SystemChatTableViewCell.identifier) as? SystemChatTableViewCell else {
            return 30
        }
        return cell.height(message.text)
    }
}

extension ChatViewController: ChatTextViewDelegate{
    func sendButtonTapped(_ sender: UIButton) {
        if chatTextView.text.count == 0{
            return
        }
        
        let message = Message(chatRoomId: chatRoom!.id!, senderId: MyProfile.id, messageType: .text, text: chatTextView.text, isRead: true)
        chatViewModel.sendMessage(message)
        chatTextView.resetText()
    }
    
    func galleryButtonTapped(_ sender: UIButton) {
        print("갤러리 버튼")
    }
    
    func youtubeButtonTapped(_ sender: UIButton) {
        let playlistViewController = PlaylistViewController()
        playlistViewController.modalPresentationStyle = .overCurrentContext
        let frame = self.youtubeView.convert(self.view.frame, to: nil)
        playlistViewController.yPoint = frame.minY + self.youtubeView.bounds.height
        self.present(playlistViewController, animated: true)
    }
    
    func setChatTextViewHeight(_ height: CGFloat) {
        self.chatTextViewHeightContraint.constant = height
    }
}
