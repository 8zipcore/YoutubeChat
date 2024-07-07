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
        let user = try await NetworkManager.sahred.sendData(to: url, resultType: User.self, params: ["user" : user])
        return user
    }
}
