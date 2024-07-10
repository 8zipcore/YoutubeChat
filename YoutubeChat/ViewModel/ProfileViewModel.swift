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
        
         guard let jsonData = try? JSONEncoder().encode(user) else {
             throw JsonError.encoding
         }
         
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(jsonData, to: url, method: .post, headers: ["Content-Type": "application/json"])
                .responseDecodable(of: User.self){ response in
                    switch response.result{
                    case .success(let data):
                        print("⭐️ 성공")
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func imageToString(image: UIImage?) -> String{
        guard let imageData = image?.pngData() else { return "" }
        return imageData.base64EncodedString()
    }
    
    func setUser(_ user: User){
        ProfileManager.shared.saveUserID(id: user.id)
        ProfileManager.shared.setMyProfile(user)
    }
}
