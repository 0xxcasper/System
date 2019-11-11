//
//  Constants.swift
//  Triip
//

import UIKit

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let Width        = UIScreen.main.bounds.size.width
    static let Height       = UIScreen.main.bounds.size.height
    static let MaxLength    = max(ScreenSize.Width, ScreenSize.Height)
    static let MinLength    = min(ScreenSize.Width, ScreenSize.Height)
}

struct Color
{
    static let GrayColor = UIColor(red:0.88, green:0.88, blue:0.89, alpha:1)
}

let SystemValue = SystemServices()
