//
//  UIColor+Extension.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//
//  Reference:
//      https://swiftuirecipes.com/blog/hex-color-in-swiftui
//      https://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
//      https://stackoverflow.com/questions/47365583/determining-text-color-from-the-background-color-in-swift/47366748
//      https://stackoverflow.com/questions/6615002/given-an-rgb-value-how-do-i-create-a-tint-or-shade/6615053
//


import SwiftUI

extension UIColor {
    convenience init?(hexString: String?) {
        let input: String! = (hexString ?? "")
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        var alpha: CGFloat = 1.0
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        
        switch (input.count) {
        case 3 /* #RGB */:
            red = Self.colorComponent(from: input, start: 0, length: 1)
            green = Self.colorComponent(from: input, start: 1, length: 1)
            blue = Self.colorComponent(from: input, start: 2, length: 1)
            break
            
        case 4 /* #ARGB */:
            alpha = Self.colorComponent(from: input, start: 0, length: 1)
            red = Self.colorComponent(from: input, start: 1, length: 1)
            green = Self.colorComponent(from: input, start: 2, length: 1)
            blue = Self.colorComponent(from: input, start: 3, length: 1)
            break
            
        case 6 /* #RRGGBB */:
            red = Self.colorComponent(from: input, start: 0, length: 2)
            green = Self.colorComponent(from: input, start: 2, length: 2)
            blue = Self.colorComponent(from: input, start: 4, length: 2)
            break
            
        case 8 /* #AARRGGBB */:
            alpha = Self.colorComponent(from: input, start: 0, length: 2)
            red = Self.colorComponent(from: input, start: 2, length: 2)
            green = Self.colorComponent(from: input, start: 4, length: 2)
            blue = Self.colorComponent(from: input, start: 6, length: 2)
            break
            
        default:
            NSException.raise(NSExceptionName("Invalid color value"), format: "Color value \"%@\" is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", arguments:getVaList([hexString ?? ""]))
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func colorComponent(from string: String!, start: Int, length: Int) -> CGFloat {
        let substring = (string as NSString)
            .substring(with: NSRange(location: start, length: length))
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent: UInt64 = 0
        Scanner(string: fullHex)
            .scanHexInt64(&hexComponent)
        return CGFloat(Double(hexComponent) / 255.0)
    }
}


extension UIColor {
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        
        return  lum < 0.50
    }
}

extension UIColor {
    
    var shade: UIColor {
        let shadeFactor = 0.08
        
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        
        let sR = r * (1 - shadeFactor)
        let sG = g * (1 - shadeFactor)
        let sB = b * (1 - shadeFactor)
        
        return UIColor(red: sR, green: sG, blue: sB, alpha: a)
    }

    var tint: UIColor {
        let tintFactor = 0.50
        
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        
        let tR = r + (1 - r) * tintFactor
        let tG = g + (1 - g) * tintFactor
        let tB = b + (1 - b) * tintFactor
        
        return UIColor(red: tR, green: tG, blue: tB, alpha: a)
    }

}
