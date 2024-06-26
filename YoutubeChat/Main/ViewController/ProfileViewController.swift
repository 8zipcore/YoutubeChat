//
//  ProfileViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var nameTextField: MakeGroupChatTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView(){
        titleLabel.setTitleLabel()
        titleLabel.text = "프로필 설정"
        nameTextField.setText(title: "이름", placeHolder: "이름을 입력하세요.")
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
