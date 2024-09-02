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
    static var description = ""
    static var image = ""
    static var backgroundImage = ""
    
    static var user: User{
        return User(id: id, name: name, description: description, image: image, backgroundImage: backgroundImage)
    }
}

class ProfileManager{
    static let shared = ProfileManager()
    
    func setMyProfile(_ user: User){
        MyProfile.id = user.id ?? UUID()
        MyProfile.name = user.name
        MyProfile.image = user.image
        MyProfile.backgroundImage = user.backgroundImage
        MyProfile.description = user.description
    }
    
    func saveUser(_ user : User){
        UserDefaults.standard.set(user.id?.uuidString, forKey: "userID")
        UserDefaults.standard.set(user.name, forKey: "userName")
        UserDefaults.standard.set(user.description, forKey: "userDescription")
        UserDefaults.standard.set(user.image, forKey: "userImage")
        UserDefaults.standard.set(user.backgroundImage, forKey: "userBackgroundImage")
        
        print("✅ 저장")
    }
    
    func deleteUser(){
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userDescription")
        UserDefaults.standard.removeObject(forKey: "userImage")
        UserDefaults.standard.removeObject(forKey: "userBackgroundImage")
    }
    
    func setUser(){
        if let id = UserDefaults.standard.string(forKey: "userID"),
           let name = UserDefaults.standard.string(forKey: "userName"),
           let description = UserDefaults.standard.string(forKey: "userDescription"),
           let image = UserDefaults.standard.string(forKey: "userImage"),
           let backgroundImage = UserDefaults.standard.string(forKey: "userBackgroundImage"){
            let user = User(id: UUID(uuidString: id), name: name, description: description, image: image, backgroundImage: backgroundImage)
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
