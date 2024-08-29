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
    static let backgroundWhite = UIColor(white: 1, alpha: 0.1)
    static let borderGray = RGB(red: 72, green: 72, blue: 72)
    static let white = RGB(red: 242, green: 242, blue: 242)
    static let blue = RGB(red: 46, green: 95, blue: 255)
    static let indigo = RGB(red: 8, green: 24, blue: 40)
    static let borderIndigo = RGB(red: 16, green: 51, blue: 83)
}
