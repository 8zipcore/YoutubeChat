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
    
    @IBOutlet weak var codeTextFieldTopConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLayoutSubviews() {
        self.codeTextFieldTopConstraint.constant = self.view.safeAreaInsets.top + 30
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.contentView.frame = CGRect(x: 0, y: -self.contentView.bounds.height, width: self.contentView.bounds.width, height: self.contentView.bounds.height)

        UIView.animate(withDuration: 0.15, animations: {
            self.backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        },completion: { _ in
            self.codeTextField.becomeFirstResponder()
        })
    }
    
    private func configureView(){
        self.view.backgroundColor = .clear
        self.backgroundView.backgroundColor = .clear
        
        self.contentView.layer.cornerRadius = self.contentView.bounds.height / 10
        
        codeTextField.delegate = self
        codeTextField.setText(title: "참여 코드", placeHolder: "참여 코드를 입력하세요.")
        confirmButton.setTitle("참여하기")
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss(_:))))
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.backgroundColor = .clear
            self.contentView.frame = CGRect(x: 0, y: -self.contentView.bounds.height, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
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
                    vc.enteredWithCode = true
                    
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
}

extension EnterChatRoomCodeViewController: InputTextFieldDelegate{
    func textFieldTextDidChange(_ sender: InputTextField) {
        if codeTextField.placeHolder != "참여 코드를 입력하세요."{
            codeTextField.setPlaceHolder("참여 코드를 입력하세요.")
        }
    }
}
