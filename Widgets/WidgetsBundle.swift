//
//  WidgetsBundle.swift
//  WidgetsExtension
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import WidgetKit
import SwiftUI


@main
struct WidgetsBundle: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        BasicNFTWidget()
        RandomNFTWidget()
        GalleryWidget()
    }
}
