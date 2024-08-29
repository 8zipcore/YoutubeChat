//
//  EnterChatRoomCodeViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/19/24.
//

import UIKit

class EnterChatRoomCodeViewController: BaseViewController {

    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var codeTextField: InputTextField!
    @IBOutlet weak var confirmButton: ConfirmButton!
    
    let chatViewModel = ChatViewModel()
    var parentNavigationController: UINavigationController?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureView(){
        self.view.backgroundColor = .black
        titleLabel.setLabel(textColor: .white, fontSize: 17)
        
        codeTextField.delegate = self
        codeTextField.setText(title: "참여 코드", placeHolder: "참여 코드를 입력하세요.")
        confirmButton.setTitle("참여하기")
    }
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        if codeTextField.isBlank(){
            codeTextField.showAnimation()
            return
        }
        
        Task {
            do{
                let data = try await chatViewModel.confirmEnterCode(enterCode: codeTextField.text)
                switch data.responseCode{
                case .invalidCode:
                    self.codeTextField.setText("")
                    self.codeTextField.setPlaceHolder("유효하지않은 코드입니다.")
                    self.codeTextField.showAnimation()
                case .validCode:
                    // chatViewModel.saveChat(chat: data.chatRoom!)
                    let vc = ChatViewController()
                    vc.chatRoom = data.chatRoom
                    vc.isEnter = true
                    
                    self.dismiss(animated: false, completion: {
                        self.parentNavigationController?.pushViewController(vc, animated: true)
                    })
                    
                    print("- - - -성공 x")
                case .existing:
                    let vc = ChatViewController()
                    vc.chatRoom = data.chatRoom
                    
                    self.dismiss(animated: false, completion: {
                        self.parentNavigationController?.pushViewController(vc, animated: true)
                    })
                }
                

            } catch {
                print("오류 - - -")
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EnterChatRoomCodeViewController: InputTextFieldDelegate{
    func textFieldTextDidChange(_ sender: InputTextField) {
        if codeTextField.placeHolder != "참여 코드를 입력하세요."{
            codeTextField.setPlaceHolder("참여 코드를 입력하세요.")
        }
    }
}
