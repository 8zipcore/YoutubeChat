//
//  Costants.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation

final class URLManager {
  static let shared = URLManager()
  
  func url(for endpoint: APIEndpoint) -> URL? {
    return URL(string: Constant.local.baseURL + endpoint.rawValue)
  }
}
