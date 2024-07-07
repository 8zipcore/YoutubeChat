//
//  MainViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/12/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var myProfileLabel: SDGothicLabel!
    @IBOutlet weak var chattingLabel: SDGothicLabel!
    @IBOutlet weak var groupChatTableView: UITableView!
    
    var chatArray:[GroupChatData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView(){
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
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func testButtonTapped(_ sender: Any) {
        self.chatArray.append(GroupChatData(chatImage: "rikus", chatName: "유튜브 챗 유튜브 챗 유튜브 챗", peopleNumber: 3, latestMessage: "빠더너스 문상훈 초대석, 쇼츠 드라마 만들기", latestChatTime: "오전 12:00"))
        
        self.groupChatTableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupChatTableView.dequeueReusableCell(withIdentifier: GroupChatTableViewCell.identifier, for: indexPath) as? GroupChatTableViewCell else { return UITableViewCell() }
        
        let groupChatData = chatArray[indexPath.item]
        
        cell.initView(groupChatData: groupChatData)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width * 194 / 1023
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "나가기") { [weak self] _, _, success in
            self?.chatArray.remove(at: indexPath.row)
            self?.groupChatTableView.deleteRows(at: [indexPath], with: .none)
            success(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        
        
        return swipeActionConfig
    }
}
