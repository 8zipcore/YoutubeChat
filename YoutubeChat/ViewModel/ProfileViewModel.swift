//
//  ProfileViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation
import Alamofire

class ProfileViewModel{
    
    func createProfile(user: UserData) async throws -> User{
        guard let url = URL(string: Constants.baseURL + Endpoints.join) else { throw HttpError.badURL }
        let uploadData = userDataToUploadData(user)
        return try await NetworkManager.shared.sendImageAndMetadata(to: url, uploadData, User.self)
    }
    
    func updateProfile(user: UserData) async throws -> User{
        guard let url = URL(string: Constants.baseURL + Endpoints.update) else { throw HttpError.badURL }
        let uploadData = userDataToUploadData(user)
        return try await NetworkManager.shared.sendImageAndMetadata(to: url, uploadData, User.self)
    }
    
    private func userDataToUploadData(_ user: UserData) -> ImageAndMetaData{
        var imageAndMetaData = ImageAndMetaData(parameters: [:], imageDataSet: [:])
        imageAndMetaData.parameters = [
            "id" : user.id,
            "name" : user.name,
            "description" : user.description
        ]
    
        if let image = user.image{
            imageAndMetaData.imageDataSet["image"] = image
        }
        
        if let backgroundImage = user.backgroundImage{
            imageAndMetaData.imageDataSet["backgroundImage"] = backgroundImage
        }
        
        return imageAndMetaData
    }
    
    func setUser(_ user: User) async throws{
        ProfileManager.shared.setMyProfile(user)
        ProfileManager.shared.saveUser(user)
    }
}
