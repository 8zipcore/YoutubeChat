//
//  MakeGroupChatViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/17/24.
//

import UIKit

class MakeGroupChatViewController: UIViewController {

    @IBOutlet weak var chatNameTextField: MakeGroupChatTextField!
    @IBOutlet weak var chatOptionLabel: SDGothicLabel!
    @IBOutlet weak var chatOptionCollectionView: UICollectionView!
    @IBOutlet weak var chatOptionCollectionViewHeight: NSLayoutConstraint!
    
    var array:[ChatOptionData] = [ChatOptionData(title: "익명으로 들어가기", isSelected: false),ChatOptionData(title: "동영상 추가 허용", isSelected: false)]
    
    let cellHeight: CGFloat = 30
    let cellSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurView()
    }
    
    private func configurView(){
        chatNameTextField.setText(title: "채팅방 이름", placeHolder: "채팅방 이름을 입력해주세요.")
        chatOptionLabel.setLabel(textColor: .black, fontSize: 13)
        
        chatOptionCollectionView.dataSource = self
        chatOptionCollectionView.delegate = self       
        chatOptionCollectionView.register(ChatOptionCollectionViewCell.self, forCellWithReuseIdentifier: ChatOptionCollectionViewCell.identifier)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
    }
}

extension MakeGroupChatViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = chatOptionCollectionView.dequeueReusableCell(withReuseIdentifier: ChatOptionCollectionViewCell.identifier, for: indexPath) as? ChatOptionCollectionViewCell else {
             return UICollectionViewCell()
        }
        
        cell.configureView(array[indexPath.item])
        
        return cell
    }
}

extension MakeGroupChatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ChatOptionCollectionViewCell.fittingSize(cellHeight: cellHeight, data: array[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension MakeGroupChatViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        array[indexPath.item].toggle()
        
        chatOptionCollectionView.reloadData()
    }
}
