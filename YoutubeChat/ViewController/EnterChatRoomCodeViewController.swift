//
//  EnterChatRoomCodeViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/19/24.
//

import UIKit

class EnterChatRoomCodeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
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
        
        UIView.animate(withDuration: 0.15, animations: {
            self.backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            self.contentView.frame = CGRect(x: 0, y: self.view.bounds.height * 0.3, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        })
    }
    
    private func configureView(){
        self.view.backgroundColor = .clear
        self.backgroundView.backgroundColor = .clear
        
        self.contentView.layer.cornerRadius = self.contentView.bounds.height / 10
        
        codeTextField.setText(title: "참여 코드", placeHolder: "참여 코드를 입력하세요.")
        confirmButton.setTitle("참여하기")
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss(_:))))
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.backgroundColor = .clear
            self.contentView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        }, completion: {_ in
            self.dismiss(animated: false)
        })
    
    }
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        if codeTextField.isBlank(){
            codeTextField.showAnimation()
            return
        }
        
        Task {
            do{
                let chat = try await chatViewModel.confirmEnterCode(enterCode: codeTextField.text)
                let vc = ChatViewController()
                vc.chatInfo = chat
                vc.enteredWithCode = true
                
                self.dismiss(animated: false, completion: {
                    self.parentNavigationController?.pushViewController(vc, animated: true)
                })
            } catch {
                print("오류 - - -")
            }
        }
    }
    
}
