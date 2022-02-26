//
//  View+Extensions.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/25/22.
//
//  References:
//      https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
//

import SwiftUI

extension View {
    func snapshot() -> UIImage? {
        var image: UIImage?
        
        DispatchQueue.main.async {
            let controller = UIHostingController(rootView: self)
            let view = controller.view

            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .clear

            let renderer = UIGraphicsImageRenderer(size: targetSize)

            image = renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
        
        return image
    }
}
