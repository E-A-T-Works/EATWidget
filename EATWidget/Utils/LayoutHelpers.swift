//
//  LayoutHelpers.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/25/22.
//

import SwiftUI

final class LayoutHelpers {
    static func stylePageTitle() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont.monospacedSystemFont(ofSize: 28.0, weight: .black)
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont.monospacedSystemFont(ofSize: 16.0, weight: .bold)
        ]
    }
}
