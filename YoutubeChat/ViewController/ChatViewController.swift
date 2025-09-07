//
//  ChatViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit

protocol ChatViewControllerDelegate{
  func dismiss()
  func reconnect()
}

class ChatViewController: BaseViewController {
  
  @IBOutlet weak var chatNameLabel: SDGothicLabel!
  @IBOutlet weak var peopleNumberLabel: SDGothicLabel!
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var chatTextView: ChatTextView!
  @IBOutlet weak var youtubeView: YoutubeView!
  @IBOutlet weak var youtubeButton: UIButton!
  
  @IBOutlet weak var youtubeViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var chatTextViewHeightContraint: NSLayoutConstraint!
  @IBOutlet weak var messageInputViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var youtubeButtonBottomConstraint: NSLayoutConstraint!
  
  private var playlistView = UIView()
  
  private let messageInputViewBottomMargin: CGFloat = 7
  private var keyboardAnimationDuraion: CGFloat = 0
  
  private let chatViewModel = ChatViewModel()
  
  private var isBackButtonClicked = false
  
  var chatRoom: ChatRoomData?
  var isEnter = false
  var isReconnected = false
  var isEnded = false
  
  private var isPresentedVC = false
  private var lastCellHeight: CGFloat = .zero
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    initData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveMessage, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveAddVideo, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveDeleteVideo, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .receiveParticipant, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reconnect(_:)), name: .reconnected, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateChatRoom(_:)), name: .updateChatRoom, object: nil)
    
    // 방만들기, 참여하기 뷰컨 없애주는 작업
    if let navigationController = self.navigationController,
       navigationController.viewControllers.count > 2 {
      var viewControllers = navigationController.viewControllers
      viewControllers.remove(at: viewControllers.count - 2)
      navigationController.setViewControllers(viewControllers, animated: true)
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    leave()
    YoutubeViewModel.shared.resetVideoArray()
    /*
     if !isBackButtonClicked{
     Task{
     try await chatViewModel.quitChatRoom(id: chatRoom!.id!)
     }
     }
     */
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    self.chatTextViewHeightContraint.constant = chatTextView.estimatedHeight()
    self.youtubeButtonBottomConstraint.constant = (self.chatTextViewHeightContraint.constant -  self.youtubeButton.bounds.height) / 2
  }
  
  private func configureView(){
    self.view.backgroundColor = .black
    
    self.hideKeyboard = false
    
    chatNameLabel.setLabel(textColor: .white, fontSize: 19)
    peopleNumberLabel.setLabel(textColor: Colors.gray, fontSize: 16)
    
    self.chatTableView.dataSource = self
    self.chatTableView.delegate = self
    
    self.chatTableView.contentInset = .zero
    self.chatTableView.scrollIndicatorInsets = .zero
    
    self.chatTextView.delegate = self
    
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
      try await YoutubeViewModel.shared.fetchVideos(id,{
        self.playVideo()
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
  
  @objc func receiveData(_ notification: Notification){
    guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
    
    if notification.name == .receiveMessage {
      if let data = notification.userInfo?["message"] as? Message{
        chatViewModel.receiveMessage(data)
        
        if data.messageType == .enter || data.messageType == .leave{
          Task {
            if let response = try await
                self.chatViewModel.findChatRoom(id: id){
              self.chatRoom = response
              DispatchQueue.main.async {
                self.peopleNumberLabel.text = String(response.participantIds.count)
              }
            }
          }
        }
        
        scrollToBottom()
      }
    } else if notification.name == .receiveAddVideo {
      if let video = notification.userInfo?["video"] as? Video {
        YoutubeViewModel.shared.appendVido(video)
        playVideo()
        NotificationCenter.default.post(name: .updatePlaylistVC, object: nil)
      }
    } else if notification.name == .receiveDeleteVideo{
      if let video = notification.userInfo?["video"] as? Video {
        let videoArray = YoutubeViewModel.shared.videoArray
        
        YoutubeViewModel.shared.removeVideo(video)
        
        if YoutubeViewModel.shared.videoArray.count == 0 {
          DispatchQueue.main.async{
            self.youtubeView.stopVideo()
            self.youtubeViewHeightConstraint.constant = 0
          }
        } else if videoArray.count > 0 && (video.id == videoArray[0].id) { // 삭제해야될게 첫번째꺼면
          isEnded = true
          playVideo()
        }
        
        NotificationCenter.default.post(name: .updatePlaylistVC, object: nil)
      }
    } else if notification.name == .receiveParticipant {
      if let data = notification.userInfo?["participant"] as? User {
        /*
         self.chatRoom = chatViewModel.setChatRoomParticipants(chatRoom: chatRoom, participantData: data)
         DispatchQueue.main.async {
         self.peopleNumberLabel.text = String(self.chatRoom!.participantIds.count)
         }*/
      }
    }
  }
  
  @objc func updateChatRoom(_ notification: Notification?){
    if let chatRoomData = notification?.userInfo?["chatRoomdata"] as? ChatRoomData{
      self.chatRoom?.name = chatRoomData.name
      self.chatRoom?.description = chatRoomData.description
      self.chatRoom?.categories = chatRoomData.categories
      self.chatRoom?.chatOptions = chatRoomData.chatOptions
      self.chatRoom?.image = chatRoomData.image
      
      DispatchQueue.main.async {
        self.chatNameLabel.text = chatRoomData.name
      }
    }
  }
  
  @objc func reconnect(_ notification: Notification?){
    let message = Message(chatRoomId: chatRoom!.id!, senderId: MyProfile.id, messageType: .reconnect, text: "")
    chatViewModel.sendMessage(message)
    
    isReconnected = true
    
    guard let chatRoom = chatRoom, let id = chatRoom.id else { print("🌀 ChatRoom Data Nil Error") ; return }
    Task{
      try await chatViewModel.fetchChats(id: id, {
        DispatchQueue.main.async {
          self.chatTableView.reloadData()
        }
      })
      
      try await YoutubeViewModel.shared.fetchVideos(id,{
        self.playVideo()
      })
    }
  }
  
  private func isTopViewController() -> Bool {
    if let navigationController = navigationController,
       navigationController.viewControllers.count > 2 {
      return false
    }
    
    return true
  }
  
  @objc func keyboardWillShow(_ notification: Notification){
    if isPresentedVC{
      return
    }
    
    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
       let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
      keyboardAnimationDuraion = animationDuration
      let keyboardHeight = keyboardFrame.height - self.view.safeAreaInsets.bottom + messageInputViewBottomMargin
      UIView.animate(withDuration: animationDuration) {
        self.messageInputViewBottomConstraint.constant = keyboardHeight
      }
    }
  }
  
  @objc func hideKeyboard(_ sender: UITapGestureRecognizer?){
    self.chatTextView.hideKeyboard()
    UIView.animate(withDuration: keyboardAnimationDuraion) {
      self.messageInputViewBottomConstraint.constant = self.messageInputViewBottomMargin
    }
  }
  
  private func playVideo(){
    print("playVideo, \(isEnded)")
    
    let videoCount = YoutubeViewModel.shared.videoArray.count
    if videoCount > 0{
      if videoCount == 1 || isEnter || isReconnected || isEnded {
        if self.youtubeViewHeightConstraint.constant == 0{
          DispatchQueue.main.async{
            self.youtubeViewHeightConstraint.constant = self.view.bounds.width * 9 / 16
          }
        }
        
        self.youtubeView.shouldSeek = isEnter || isReconnected
        
        let video = YoutubeViewModel.shared.videoArray[0]
        DispatchQueue.main.async{
          self.youtubeView.playVideo(video)
        }
        isReconnected = false
        isEnter = false
        isEnded = false
      } /*else {
         let video = YoutubeViewModel.shared.videoArray[0]
         let currentTime = Date().timeIntervalSince1970
         if video.startTime < currentTime {
         DispatchQueue.main.async{
         self.youtubeView.playVideo(video)
         }
         }
         }*/
    } else {
      isReconnected = false
      isEnter = false
      isEnded = false
    }
    
    if self.chatViewModel.messageArray.count > 0 {
      scrollToBottom()
    }
  }
  
  private func scrollToBottom(){
    DispatchQueue.main.async{
      self.chatTableView.reloadData()
      self.chatTableView.layoutIfNeeded()
      self.chatTableView.scrollToRow(at: IndexPath(row: self.chatViewModel.messageArray.count - 1, section: 0), at: .bottom, animated: false)
    }
  }
}
// MARK: ButtonTapped
extension ChatViewController{
  @IBAction func backButtonTapped(_ sender: Any) {
    isBackButtonClicked = true
    leave()
  }
  
  @IBAction func testButtonTapped(_ sender: Any) {
    DispatchQueue.main.async{
      self.youtubeViewHeightConstraint.constant = self.view.bounds.width * 9 / 16
      if self.chatViewModel.messageArray.count > 0 {
        self.scrollToBottom()
      }
    }
  }
  
  @IBAction func menuButtonTapped(_ sender: Any) {
    hideKeyboard(nil)
    
    let vc = ChatMenuViewController()
    vc.chatRoom = chatRoom
    vc.delegate = self
    vc.modalPresentationStyle = .overCurrentContext
    self.present(vc, animated: false)
    
    isPresentedVC = true
  }
  
  @IBAction func youtubeButtonTapped(_ sender: Any) {
    guard let chatRoom = chatRoom else { print("🌀 ChatRoom Data Nil Error") ; return }
    
    hideKeyboard(nil)
    
    let vc = PlaylistViewController()
    vc.chatViewModel = self.chatViewModel
    vc.delegate = self
    
    let frame = self.youtubeView.convert(self.view.frame, to: nil)
    vc.yPoint = frame.minY + self.view.bounds.width * 9 / 16
    vc.viewWidth = self.view.bounds.width
    vc.chatRoom = chatRoom
    
    playlistView = vc.view
    
    self.view.addSubview(playlistView)
    
    /*
     vc.modalPresentationStyle = .overCurrentContext
     self.present(vc, animated: true, completion: {
     self.isPresentedPlaylistVC = true
     })*/
  }
  
  @IBAction func syncVideoButtonTapped(_ sender: Any) {
    youtubeView.seekVideo()
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
      case .addVideo:fallthrough
      case .deleteVideo:fallthrough
        /*
         let nib = UINib(nibName: ImageChatTableViewCell.identifier, bundle: nil)
         self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatTableViewCell.identifier)
         
         guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatTableViewCell.identifier) as? ImageChatTableViewCell else {
         return UITableViewCell()
         }
         
         let image = UIImage(named: message.image!)!
         cell.setImage(image: image)
         
         return cell
         */
      case .enter:fallthrough
      case .leave:fallthrough
      case .reconnect:break
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
      case .addVideo:fallthrough
      case .deleteVideo:fallthrough
        /*
         let nib = UINib(nibName: ImageChatWithProfileTableViewCell.identifier, bundle: nil)
         self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatWithProfileTableViewCell.identifier)
         
         guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatWithProfileTableViewCell.identifier) as? ImageChatWithProfileTableViewCell else {
         return UITableViewCell()
         }
         
         let image = UIImage(named: message.image!)!
         cell.setImage(image: image, profileHidden: chatViewModel.isPrevSender(indexPath.item))
         
         return cell
         */
      case .enter:fallthrough
      case .leave:fallthrough
      case .reconnect:break
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
      case .addVideo:fallthrough
      case .deleteVideo:fallthrough
        /*
         let nib = UINib(nibName: ImageChatTableViewCell.identifier, bundle: nil)
         self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatTableViewCell.identifier)
         
         guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatTableViewCell.identifier) as? ImageChatTableViewCell else {
         return .zero
         }
         
         let image = UIImage(named: message.image!)!
         return cell.estimatedHeight(image: image)
         */
      case .enter:fallthrough
      case .leave:fallthrough
      case .reconnect:break
      }
    } else { // MARK: 남이 보낸 챗
      switch message.messageType{
      case .text:
        guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatWithProfileTableViewCell.identifier) as? ChatWithProfileTableViewCell else {
          return .zero
        }
        
        return cell.estimatedHeight(text: message.text, profileHidden: chatViewModel.isPrevSender(indexPath.item))
      case .image:fallthrough
      case .addVideo:fallthrough
      case .deleteVideo:fallthrough
        /*
         let nib = UINib(nibName: ImageChatWithProfileTableViewCell.identifier, bundle: nil)
         self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatWithProfileTableViewCell.identifier)
         
         guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatWithProfileTableViewCell.identifier) as? ImageChatWithProfileTableViewCell else {
         return .zero
         }
         
         let image = UIImage(named: message.image!)!
         return cell.estimatedHeight(image: image, profileHidden: chatViewModel.isPrevSender(indexPath.item))
         */
      case .enter:fallthrough
      case .leave:fallthrough
      case .reconnect:break
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
  func sendButtonTapped() {
    if chatTextView.isBlank {
      return
    }
    
    let message = Message(chatRoomId: chatRoom!.id!, senderId: MyProfile.id, messageType: .text, text: chatTextView.text)
    chatViewModel.sendMessage(message)
    chatTextView.resetText()
    self.chatTextViewHeightContraint.constant = chatTextView.estimatedHeight()
  }
  
  func setChatTextViewHeight(_ height: CGFloat) {
    self.chatTextViewHeightContraint.constant = height
  }
}

// MARK: YoutubeViewDelegate
extension ChatViewController: YoutubeViewDelegate{
  func didStartVideo(_ video: Video) {
    /*
     guard let chatRoom = chatRoom, let videoId = video.id else { print("🌀 ChatRoom Data Nil Error") ; return }
     if (chatRoom.hostId == MyProfile.id) && !isReconnected{
     Task{
     // try await YoutubeViewModel.shared.updateStartTime(chatRoom.id!, videoId)
     }
     }
     */
  }
  
  func didEndVideo(_ video: Video) {
    print("😀 End")
    NotificationCenter.default.post(name: .receiveDeleteVideo, object: nil, userInfo: ["video" : video])
  }
}

extension ChatViewController: ChatViewControllerDelegate{
  func dismiss() {
    self.playlistView.removeFromSuperview()
    isPresentedVC = false
    hideKeyboard(nil)
  }
  func reconnect() {
    reconnect(nil)
  }
}
