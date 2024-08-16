//
//  MainViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/12/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var myProfileLabel: SDGothicLabel!
    @IBOutlet weak var chattingLabel: SDGothicLabel!
    @IBOutlet weak var groupChatTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private let cellHeight: CGFloat = 30
    private let cellSpacing: CGFloat = 6
    
    var chatViewModel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configureView(){
        profileView.setMyProfile()
        
        myProfileLabel.text = "내 프로필"
        chattingLabel.text = "채팅"
        
        myProfileLabel.textColor = .black
        myProfileLabel.font = SDGothic(size: 15)
        myProfileLabel.setLetterSpacing(0.4)
        
        chattingLabel.textColor = .black
        chattingLabel.font = SDGothic(size: 15)
        chattingLabel.setLetterSpacing(0.4)
        
        let groupChatTableViewCellNib = UINib(nibName: GroupChatTableViewCell.identifier, bundle: nil)
        groupChatTableView.register(groupChatTableViewCellNib, forCellReuseIdentifier: GroupChatTableViewCell.identifier)
        
        groupChatTableView.dataSource = self
        groupChatTableView.delegate = self
        
        groupChatTableView.bounces = false
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(ChatOptionCollectionViewCell.self, forCellWithReuseIdentifier: ChatOptionCollectionViewCell.identifier)
    }
    
    private func initData(){
        Task{
            try await chatViewModel.fetchAllChatRooms({
                DispatchQueue.main.async{
                    self.groupChatTableView.reloadData()
                }
            })
        }
    }
    
    @IBAction func creatGroupChatButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "채팅방 만들기", style: .default, handler: {_ in
            let vc = CreateChatRoomViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "채팅방 참여하기", style: .default, handler: {_ in 
            let vc = EnterChatRoomCodeViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.parentNavigationController = self.navigationController
            self.present(vc, animated: false)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {
        
        initData()
        
        // 데이터 삭제
        /*
         ProfileManager.shared.deleteUser()
         CoreDataManager.shared.deleteAllData()
        */
        
        /*
        self.chatArray.append(GroupChatData(chatImage: "rikus", chatName: "유튜브 챗 유튜브 챗 유튜브 챗", peopleNumber: 3, latestMessage: "빠더너스 문상훈 초대석, 쇼츠 드라마 만들기", latestChatTime: "오전 12:00"))
        
        self.groupChatTableView.reloadData()
         */
    }
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewModel.chatRoomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupChatTableView.dequeueReusableCell(withIdentifier: GroupChatTableViewCell.identifier, for: indexPath) as? GroupChatTableViewCell else { return UITableViewCell() }
        
        let chat = chatViewModel.chatRoomArray[indexPath.item]
        
        cell.initView(chatRoom: chat)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width * 194 / 1023
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatRoomInfoViewController()
        vc.chatRoom = self.chatViewModel.chatRoomArray[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "나가기") { [weak self] _, _, success in
            self?.chatViewModel.chatRoomArray.remove(at: indexPath.row)
            self?.groupChatTableView.deleteRows(at: [indexPath], with: .none)
            success(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        
        
        return swipeActionConfig
    }*/
}

//MARK: CollectionView 관련
extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatViewModel.categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: ChatOptionCollectionViewCell.identifier, for: indexPath) as? ChatOptionCollectionViewCell else {
             return UICollectionViewCell()
        }
        let category = chatViewModel.categoryArray[indexPath.item]
        cell.configureView(title: category.title, isSelected: category.isSelected)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = chatViewModel.categoryArray[indexPath.item]
        return ChatOptionCollectionViewCell.fittingSize(cellHeight: cellHeight, title: category.title, isSelected: category.isSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chatViewModel.categoryArray[indexPath.item].toggle()
        categoryCollectionView.reloadData()
    }
}
