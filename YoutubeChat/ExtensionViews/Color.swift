//
//  Color.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/19/24.
//

import UIKit

func RGB(red: Int, green: Int, blue: Int)-> UIColor{
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
}

func RGB(red: Int, green: Int, blue: Int, alpha: CGFloat)-> UIColor{
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
}

struct Colors{
    static let lightGray = RGB(red: 245, green: 245, blue: 245)
    static let gray = RGB(red: 167, green: 163, blue: 163)
    static let white = RGB(red: 253, green: 253, blue: 253)
    static let blue = RGB(red: 0, green: 145, blue: 233)
    static let skyBlue = RGB(red: 235, green: 247, blue: 255)
}
