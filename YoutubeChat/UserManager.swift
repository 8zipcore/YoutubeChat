//
//  UserManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation

class UserManager{
    static let shared = UserManager()
    
    func saveUserID(id : UUID){
        UserDefaults.standard.set(id, forKey: "userID")
        print("✅ id 저장")
    }
    
    func isSavedID()-> Bool{
        let id = UserDefaults.standard.string(forKey: "userID")
        return id == nil ? false : true
    }
}
