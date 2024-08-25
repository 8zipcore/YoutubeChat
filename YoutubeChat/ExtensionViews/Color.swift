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
    static let pastelBlue = RGB(red: 227, green: 245, blue: 255)
    static let skyBlue = RGB(red: 60, green: 147, blue: 236)
    static let trueBlue = RGB(red: 94, green: 158, blue: 247)
    static let mint = RGB(red: 231, green: 252, blue: 211)
    static let violet = RGB(red: 91, green: 49, blue: 89)
}
