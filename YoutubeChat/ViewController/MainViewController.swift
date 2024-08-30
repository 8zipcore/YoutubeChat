//
//  MainViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/12/24.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var myProfileLabel: SDGothicLabel!
    @IBOutlet weak var chattingLabel: SDGothicLabel!
    @IBOutlet weak var groupChatTableView: UITableView!
    @IBOutlet weak var fetchChatRoomButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private let cellHeight: CGFloat = 30
    private let cellSpacing: CGFloat = 6
    
    var chatViewModel = ChatViewModel()
    var searchViewModel = SearchViewModel()
    
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
        self.view.backgroundColor = .black
        
        let profileViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(_:)))
        profileView.addGestureRecognizer(profileViewTapGestureRecognizer)
        
        myProfileLabel.text = "내 프로필"
        chattingLabel.text = "채팅"
        
        myProfileLabel.textColor = .white
        myProfileLabel.font = SDGothic(size: 15)
        myProfileLabel.setLetterSpacing(0.4)
        
        chattingLabel.textColor = .white
        chattingLabel.font = SDGothic(size: 15)
        chattingLabel.setLetterSpacing(0.4)
        
        let groupChatTableViewCellNib = UINib(nibName: GroupChatTableViewCell.identifier, bundle: nil)
        groupChatTableView.register(groupChatTableViewCellNib, forCellReuseIdentifier: GroupChatTableViewCell.identifier)
        groupChatTableView.dataSource = self
        groupChatTableView.delegate = self
        groupChatTableView.bounces = false
        groupChatTableView.backgroundColor = .clear
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(ChatOptionCollectionViewCell.self, forCellWithReuseIdentifier: ChatOptionCollectionViewCell.identifier)
    }
    
    private func initData(){
        profileView.setMyProfile()
        Task{
            try await chatViewModel.fetchAllChatRooms({
                DispatchQueue.main.async{
                    self.groupChatTableView.reloadData()
                }
            })
            let response = try await searchViewModel.fetchCategories()
            searchViewModel.setTop5Categories(response)
            DispatchQueue.main.async{
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func creatGroupChatButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "채팅방 만들기", style: .default, handler: {_ in
            let vc = CreateChatRoomViewController()
            vc.viewType = .create
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "채팅방 참여하기", style: .default, handler: {_ in 
            let vc = EnterChatRoomCodeViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.parentNavigationController = self.navigationController
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {
        // 데이터 삭제
         ProfileManager.shared.deleteUser()
         CoreDataManager.shared.deleteAllData()
    }
    
    @IBAction func fetchChatRoomButtonTapped(_ sender: Any) {
        initData()
    }
    
    @IBAction func conntectWebSocketButtonTapped(_ sender: Any) {
        WebSocketManager.shared.connect()
    }
    
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer){
        let vc = ProfileInfoViewController()
        vc.user = MyProfile.user
        vc.viewType = .myProfile
        self.navigationController?.pushViewController(vc, animated: true)
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
        return searchViewModel.top5Categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: ChatOptionCollectionViewCell.identifier, for: indexPath) as? ChatOptionCollectionViewCell else {
             return UICollectionViewCell()
        }
        
        if indexPath.item == 0{
            let image = searchIconImage()
            cell.configureView(image: image, title: "검색", isSelected: true)
        } else {
            let category = searchViewModel.top5Categories[indexPath.item - 1]
            cell.configureView(image: nil, title: category.title, isSelected: category.isSelected)
        }
        
        return cell
    }
    
    private func searchIconImage()-> UIImage?{
        if let image = UIImage(named: "search_icon")?.withRenderingMode(.alwaysTemplate){
            return image.withTintColor(Colors.blue)
        }
        return nil
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let image = searchIconImage()
            return ChatOptionCollectionViewCell.fittingSize(cellHeight: cellHeight, image: image, title: "검색", isSelected: false)
        } else {
            let category = searchViewModel.top5Categories[indexPath.item - 1]
            return ChatOptionCollectionViewCell.fittingSize(cellHeight: cellHeight, image: nil, title: category.title, isSelected: category.isSelected)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let vc = SearchChatRoomViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // 취소하는거면 unselected
            if searchViewModel.top5Categories[indexPath.item - 1].isSelected == true {
                Task{
                    try await chatViewModel.fetchAllChatRooms({
                        DispatchQueue.main.async{
                            self.groupChatTableView.reloadData()
                        }
                    })
                }
            } else {
                searchViewModel.resetTop5CategoriesSelection()
                Task{
                    let category = searchViewModel.top5Categories[indexPath.item - 1].title
                    let response = try await self.searchViewModel.fetchChatRooms(category)
                    self.chatViewModel.chatRoomArray = response
                    DispatchQueue.main.async{
                        self.groupChatTableView.reloadData()
                    }
                }
            }
            searchViewModel.top5Categories[indexPath.item - 1].toggle()
            categoryCollectionView.reloadData()
        }
    }
}
