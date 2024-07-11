//
//  ProfileViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation
import Alamofire

class ProfileViewModel{
    
    func createProfile(user: User) async throws -> User{
        guard let url = URL(string: Constants.baseURL + Endpoints.join) else { throw HttpError.badURL }
        
        return try await NetworkManager.shared.sendJsonData(user, to: url)
    }
    
    func setUser(_ user: User){
        ProfileManager.shared.setMyProfile(user)
    }
}
