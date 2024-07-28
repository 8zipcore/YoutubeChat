//
//  ProfileManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import UIKit

enum MyProfile{
    static var id = UUID()
    static var name = ""
    static var image: UIImage?
    static var statusMessage = ""
}

class ProfileManager{
    static let shared = ProfileManager()
    
    func setMyProfile(_ user: User){
        MyProfile.id = user.id ?? UUID()
        MyProfile.name = user.name
        if !user.image.isEmpty, let imageData = Data(base64Encoded: user.image) {
            MyProfile.image = UIImage(data: imageData)
        }
        MyProfile.statusMessage = user.statusMessage
    }
    
    func saveUser(_ user : User){
        UserDefaults.standard.set(user.id?.uuidString, forKey: "userID")
        UserDefaults.standard.set(user.name, forKey: "userName")
        UserDefaults.standard.set(user.image, forKey: "userImage")
        UserDefaults.standard.set(user.statusMessage, forKey: "userStatusMessage")
        
        print("✅ 저장")
    }
    
    func deleteUser(){
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userImage")
        UserDefaults.standard.removeObject(forKey: "userStatusMessage")
    }
    
    func setUser(){
        if let id = UserDefaults.standard.string(forKey: "userID"),
           let name = UserDefaults.standard.string(forKey: "userName"),
           let image = UserDefaults.standard.string(forKey: "userImage"),
           let statusMessage = UserDefaults.standard.string(forKey: "userStatusMessage"){
            let user = User(id: UUID(uuidString: id), name: name, image: image, statusMessage: statusMessage, chatID: [])
            setMyProfile(user)
        }
    }
    
    func isSavedID()-> Bool{
        let id = UserDefaults.standard.string(forKey: "userID")
        return id == nil ? false : true
    }
    
    func isMyID(_ id: UUID)-> Bool{
        return id == MyProfile.id
    }
}
