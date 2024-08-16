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

    @IBOutlet weak var youtubeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var messageInputViewBottomConstraint: NSLayoutConstraint!
    
    private let messageInputViewBottomMargin: CGFloat = 7
    private var keyboardAnimationDuraion: CGFloat = 0

    private let chatViewModel = ChatViewModel()
    private let youtubeViewModel = YoutubeViewModel()
    
    private var isBackButtonClicked = false
    
    var chatRoom: ChatRoomData?
    var isEnter = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isBackButtonClicked{
            Task{
                try await chatViewModel.quitChatRoom(id: chatRoom!.id!)
            }
        }
    }
    
    private func configureView(){
        chatNameLabel.setLabel(textColor: .black, fontSize: 15)
        peopleNumberLabel.setLabel(textColor: Colors.gray, fontSize: 13)
        
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        
        self.chatTextView.delegate = self
                
        self.chatTextViewHeightContraint.constant = self.view.bounds.height * 0.04
        
        chatTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:))))
        
        guard let chatRoom = chatRoom else { print("🌀 ChatRoom Data Nil Error") ; return }
        chatNameLabel.text = chatRoom.name
        peopleNumberLabel.text = String(chatRoom.participantIds.count)
        
        youtubeViewHeightConstraint.constant = 0
        youtubeView.delegate = self
    }
    
    private func initData(){
        guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        Task{
            self.chatViewModel.sendEnterMessage(id)
            try await youtubeViewModel.fetchVideos(id,{
                self.playYoutube()
            })
        }
    }
    
    private func leave(){
        guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        Task{
            let responseData = try await self.chatViewModel.leaveChatRoom(id: id)
            print(responseData)
            switch responseData.responseCode {
            case .success:
                self.navigationController?.popToRootViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.chatViewModel.sendLeaveMessage(id)
                }
            case .failure:
                print("🌀 채팅방 나가기 실패")
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        isBackButtonClicked = true
        leave()
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {

    }
    
    @objc func receiveData(_ notification: Notification){
        guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        
        if notification.name == .receiveMessage {
            if let data = notification.userInfo?["message"] as? Message{
                chatViewModel.receiveMessage(data)
                DispatchQueue.main.async {
                    self.chatTableView.reloadData()
                    self.chatTableView.scrollToRow(at: IndexPath(row: self.chatViewModel.messageArray.count - 1, section: 0), at: .bottom, animated: true)
                }
                if data.messageType == .enter || data.messageType == .leave {
                    Task {
                        let response = try await self.chatViewModel.findChatRoom(id: id)
                        self.chatRoom = response
                        DispatchQueue.main.async {
                            self.peopleNumberLabel.text = String(response.participants.count)
                        }
                    }
                }
            }
        } else if notification.name == .receiveVideo {
            if let data = notification.userInfo?["video"] as? AddVideoResponseData {
               youtubeViewModel.videoArray = data.videos
               playYoutube()
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
    
    private func playYoutube(){
        if self.youtubeViewModel.videoArray.count > 0{
            if self.youtubeViewHeightConstraint.constant == 0{
                DispatchQueue.main.async{
                    self.youtubeViewHeightConstraint.constant = self.view.bounds.width * 9 / 16
                }
            }
            let videoArrayCount = self.youtubeViewModel.videoArray.count
            if videoArrayCount == 1 || isEnter{
                let video = self.youtubeViewModel.videoArray[0]
                self.youtubeView.shouldSeek = isEnter
                DispatchQueue.main.async{
                    self.youtubeView.playYoutube(video)
                }
                isEnter = false
            }
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
                
                let user = chatViewModel.findUser(chatRoom: chatRoom, senderId: message.senderId)
                
                cell.setText(text: message.text, user: user, profileHidden: chatViewModel.isPrevSender(indexPath.item))
                
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

// MARK: ChatTextViewDelegate
extension ChatViewController: ChatTextViewDelegate{
    func sendButtonTapped(_ sender: UIButton) {
        if chatTextView.isBlank {
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
        guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        
        let vc = PlaylistViewController()
        vc.chatViewModel = self.chatViewModel
        vc.youtubeViewModel = self.youtubeViewModel
        
        let frame = self.youtubeView.convert(self.view.frame, to: nil)
        vc.yPoint = frame.minY + self.view.bounds.width * 9 / 16
        vc.chatRoomId = id
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    func setChatTextViewHeight(_ height: CGFloat) {
        self.chatTextViewHeightContraint.constant = height
    }
}

// MARK: YoutubeViewDelegate
extension ChatViewController: YoutubeViewDelegate{
    func didStartVideo(_ video: Video) {
        guard let chatRoom = chatRoom, let videoId = video.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        if chatRoom.hostId == MyProfile.id{
            Task{
                try await self.youtubeViewModel.updateStartTime(chatRoom.id!, videoId)
            }
        }
    }
    
    func didEndVideo(_ video: Video) {
        guard let chatRoom = chatRoom, let videoId = video.id else { print("🌀 ChatRoom Data Nil Error") ; return }
        
        if let index = self.youtubeViewModel.videoArray.firstIndex(where: { $0.id == video.id }) {
            self.youtubeViewModel.videoArray.remove(at: index)
            let addVideoResponseData = AddVideoResponseData(responseCode: .success, videos: self.youtubeViewModel.videoArray)
            NotificationCenter.default.post(name: .receiveVideo, object: nil, userInfo: ["video" : addVideoResponseData])
            Task{
                try await self.youtubeViewModel.deleteVideo(chatRoom.id!, videoId)
            }
            // 아예 없으면
            if self.youtubeViewModel.videoArray.count == 0{
                youtubeViewHeightConstraint.constant = 0
            }
        }
    }
}
