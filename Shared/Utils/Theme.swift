//
//  Theme.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/9/22.
//
//  References:
//      https://blog.techchee.com/navigation-bar-title-style-color-and-custom-back-button-in-swiftui/
//

import SwiftUI

final class Theme {
    
    static func navigationBarColors(
        background: UIColor?,
        titleColor: UIColor? = nil,
        tintColor: UIColor? = nil
    ){
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        navigationAppearance.shadowColor = .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
    
    static func backgroundColorForPage() -> UIColor {
        // 82, 82, 82
        return UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.0)
    }
    
    static func foregroundColorForPage() -> UIColor {
        return .white
    }
    
    static func bakgroundColorForCard() -> UIColor {
        // 134 134 134
        return UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.0)
    }
    
    static func foregroundColorForCard() -> UIColor {
        return .white
    }
    
    static func backgroundColorForSheet() -> UIColor {
        // 82, 82, 82
        return UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.0)
    }
    
    static func foregroundColorForSheet() -> UIColor {
        return .white
    }
    
    static func tintColor() -> UIColor {
        return UIColor(Color.accentColor)
    }
    
    
    static func resolveColorsFromImage(imageUrl: URL?, preferredBackgroundColor: UIColor?) -> DerivedColors {
        var backgroundColor: UIColor
        var foregroundColor: UIColor
        
        if preferredBackgroundColor != nil {
            backgroundColor = preferredBackgroundColor!
            foregroundColor = backgroundColor.isDarkColor ? .white : .black
            
            return DerivedColors(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor
            )
            
        }
        
        if imageUrl == nil {
            backgroundColor = .clear
            foregroundColor = .black
            
            return DerivedColors(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor
            )
        }
        
        let data = try? Data(contentsOf: imageUrl!)
        let uiImage = UIImage(data: data!)
        
        backgroundColor = uiImage?.averageColor?.tint ?? .clear
        foregroundColor = backgroundColor.isDarkColor ? .white : .black
        
        return DerivedColors(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        )
    }
    
}


