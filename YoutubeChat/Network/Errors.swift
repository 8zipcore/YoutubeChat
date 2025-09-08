//
//  Errors.swift
//  YoutubeChat
//
//  Created by 홍승아 on 9/8/25.
//

import Foundation

enum HttpError: Error {
  case badURL, badResponse, errorDecodingData, invalidURL
}

enum JsonError: Error {
  case encoding, decoding;
}
