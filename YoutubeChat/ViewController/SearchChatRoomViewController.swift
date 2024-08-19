//
//  SearchChatRoomViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/17/24.
//

import UIKit

class SearchChatRoomViewController: UIViewController {

    @IBOutlet weak var textField: URLInputTextField!
    @IBOutlet weak var chatOptionCollectionView: UICollectionView!
    @IBOutlet weak var groupChatTableView: UITableView!
    
    private let cellHeight: CGFloat = 30
    private let cellSpacing: CGFloat = 6
    
    let searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView(){
        let groupChatTableViewCellNib = UINib(nibName: GroupChatTableViewCell.identifier, bundle: nil)
        groupChatTableView.register(groupChatTableViewCellNib, forCellReuseIdentifier: GroupChatTableViewCell.identifier)
        
        groupChatTableView.dataSource = self
        groupChatTableView.delegate = self
        
        groupChatTableView.bounces = false
        
        chatOptionCollectionView.register(ChatOptionCollectionViewCell.self, forCellWithReuseIdentifier: ChatOptionCollectionViewCell.identifier)
        chatOptionCollectionView.dataSource = self
        chatOptionCollectionView.delegate = self
        
        textField.delegate = self
        textField.type = .search
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchChatRoomViewController: URLInputTextFieldDelegate{
    func textFieldDidChange(_ text: String) {
        Task{
            let response = try await searchViewModel.searchChatRoom(text, searchViewModel.selectedChatOptionArray())
            searchViewModel.chatRoomArray = response
            DispatchQueue.main.async{
                self.groupChatTableView.reloadData()
            }
        }
    }
}

extension SearchChatRoomViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.chatRoomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupChatTableView.dequeueReusableCell(withIdentifier: GroupChatTableViewCell.identifier, for: indexPath) as? GroupChatTableViewCell else { return UITableViewCell() }
        let chatRoom = searchViewModel.chatRoomArray[indexPath.item]
        cell.initView(chatRoom: chatRoom)
        return cell
    }
}

extension SearchChatRoomViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width * 194 / 1023
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatRoomInfoViewController()
        vc.chatRoom = self.searchViewModel.chatRoomArray[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchChatRoomViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModel.chatOptionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = chatOptionCollectionView.dequeueReusableCell(withReuseIdentifier: ChatOptionCollectionViewCell.identifier, for: indexPath) as? ChatOptionCollectionViewCell else {
             return UICollectionViewCell()
        }
        let option = searchViewModel.chatOptionArray[indexPath.item]
        cell.configureView(title: option.title, isSelected: option.isSelected)
        return cell
    }
}

extension SearchChatRoomViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = searchViewModel.chatOptionArray[indexPath.item]
        return ChatOptionCollectionViewCell.fittingSize(cellHeight: cellHeight, title: category.title, isSelected: category.isSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension SearchChatRoomViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchViewModel.chatOptionArray[indexPath.item].toggle()
        chatOptionCollectionView.reloadData()
    }
}