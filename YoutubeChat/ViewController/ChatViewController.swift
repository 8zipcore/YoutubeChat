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
    
    var data: [ChatData] = []
    
    var count = 0
    
    var chatInfo: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WebSocketManager.shared.connect()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addMessageData(_:)), name: .receiveMessage, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WebSocketManager.shared.disconnect()
    }
    
    private func configureView(){
        chatNameLabel.setLabel(textColor: .black, fontSize: 15)
        peopleNumberLabel.setLabel(textColor: Colors.gray, fontSize: 13)
        
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        
        self.chatTextView.chatTextViewHeightDelegate = self
                
        self.chatTextViewHeightContraint.constant = chatTextView.estimatedHeight()
        
        if let chatInfo = chatInfo {
            chatNameLabel.text = chatInfo.chatName
            peopleNumberLabel.text = String(chatInfo.participantID.count)
        }
    }

    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let chatInfo = chatInfo else { return }
        let chatData = ChatData(id: nil, groupChatID: chatInfo.id!, senderID: MyProfile.id, messageType: .text, message: chatTextView.text, image: "", timestamp: TimeInterval())
        WebSocketManager.shared.sendMessage(chatData)
        data.append(chatData)
        chatTableView.reloadData()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {
        let playlistViewController = PlaylistViewController()
        playlistViewController.modalPresentationStyle = .overCurrentContext
        let frame = self.youtubeView.convert(self.view.frame, to: nil)
        playlistViewController.yPoint = frame.minY + self.youtubeView.bounds.height
        self.present(playlistViewController, animated: true)

//        let imageName = ["riku", "saku", "rikus", "testImage", "testImage2"]
//        
//        count = count + 1 == imageName.count ? 0 : count + 1
//        addImageData(name: "리코", imgName: imageName[count])
//        
//        chatTableView.reloadData()
//
//        chatTableView.scrollToRow(at: IndexPath(row: self.data.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    @objc func addMessageData(_ notification: Notification){
        guard let chatData = notification.userInfo?["chatData"] as? ChatData else { return }
        data.append(chatData)
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
        }
        
    }
    
    func addImageData(name:String, imgName: String){

    }
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatData = data[indexPath.item]
        
        if chatData.senderID == MyProfile.id{
            if chatData.image == ""{ // chatdata일 때
                let nib = UINib(nibName: ChatTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier) as? ChatTableViewCell else {
                    return UITableViewCell()
                }

                cell.setText(text: chatData.message)
                
                return cell
            } else {
                let nib = UINib(nibName: ImageChatTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatTableViewCell.identifier) as? ImageChatTableViewCell else {
                    return UITableViewCell()
                }
                
                let image = UIImage(named: chatData.image)!
                cell.setImage(image: image)
                
                return cell
            }
        } else {
            if chatData.image == ""{ // chatdata일 때
                let nib = UINib(nibName: ChatWithProfileTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ChatWithProfileTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatWithProfileTableViewCell.identifier) as? ChatWithProfileTableViewCell else {
                    return UITableViewCell()
                }
                
                var profileHidden = false
                
                if indexPath.item != 0 {
                    let previousUser = data[indexPath.item - 1]
                    if chatData.senderID == previousUser.senderID{
                        profileHidden = true
                    }
                }
                
                cell.setText(text: chatData.message, profileHidden: profileHidden)
                
                return cell
            } else { // 이미지 데이터
                let nib = UINib(nibName: ImageChatWithProfileTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatWithProfileTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatWithProfileTableViewCell.identifier) as? ImageChatWithProfileTableViewCell else {
                    return UITableViewCell()
                }
                
                var profileHidden = false
                
                if indexPath.item != 0 {
                    let previousUser = data[indexPath.item - 1]
                    if chatData.senderID == previousUser.senderID{
                        profileHidden = true
                    }
                }
                
                let image = UIImage(named: chatData.image)!
                cell.setImage(image: image, profileHidden: profileHidden)
                
                return cell
            }
 
        }
    }
}

extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatData = data[indexPath.item]
        
        if chatData.senderID == MyProfile.id{
            if chatData.image == ""{
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier) as? ChatTableViewCell else {
                    return .zero
                }
                
                return cell.estimatedHeight(text: chatData.message)
            } else {
                let nib = UINib(nibName: ImageChatTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatTableViewCell.identifier) as? ImageChatTableViewCell else {
                    return .zero
                }
                
                let image = UIImage(named: chatData.image)!
                return cell.estimatedHeight(image: image)
            }
        } else {
            if chatData.image == ""{
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ChatWithProfileTableViewCell.identifier) as? ChatWithProfileTableViewCell else {
                    return .zero
                }
                
                var profileHidden = false
                
                if indexPath.item != 0 {
                    let previousUser = data[indexPath.item - 1]
                    if chatData.senderID == previousUser.senderID{
                        profileHidden = true
                    }
                }
                
                return cell.estimatedHeight(text: chatData.message, profileHidden: profileHidden)
            } else { // 이미지 데이터
                let nib = UINib(nibName: ImageChatWithProfileTableViewCell.identifier, bundle: nil)
                self.chatTableView.register(nib, forCellReuseIdentifier: ImageChatWithProfileTableViewCell.identifier)
                
                guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: ImageChatWithProfileTableViewCell.identifier) as? ImageChatWithProfileTableViewCell else {
                    return .zero
                }
                
                var profileHidden = false
                
                if indexPath.item != 0 {
                    let previousUser = data[indexPath.item - 1]
                    if chatData.senderID == previousUser.senderID{
                        profileHidden = true
                    }
                }
                
                let image = UIImage(named: chatData.image)!
                return cell.estimatedHeight(image: image, profileHidden: profileHidden)
            }
        }
 
    }
}

extension ChatViewController: ChatTextViewDelegate{
    func setChatTextViewHeight(_ height: CGFloat) {
        self.chatTextViewHeightContraint.constant = height
    }
}