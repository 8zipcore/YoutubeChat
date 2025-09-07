//
//  CategoryData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/14/24.
//

import Foundation

struct CategoryData{
  var title: String
  var isSelected: Bool
  
  mutating func toggle(){
    isSelected.toggle()
  }
  
  init(title: String){
    self.title = title
    self.isSelected = false
  }
}
