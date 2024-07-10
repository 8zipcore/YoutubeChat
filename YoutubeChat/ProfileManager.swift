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
    
    func saveUserID(id : UUID?){
        UserDefaults.standard.set(id?.uuidString, forKey: "userID")
        print("✅ id 저장")
    }
    
    func isSavedID()-> Bool{
        let id = UserDefaults.standard.string(forKey: "userID")
        return id == nil ? false : true
    }
}
