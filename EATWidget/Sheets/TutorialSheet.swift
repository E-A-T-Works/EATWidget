//
//  TutorialSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/28/22.
//

import SwiftUI

struct TutorialSheet: View {
    @State private var index = 0
    
    var body: some View {
        
        Carousel(list: [
            CarouselCardContent(
                title: "1. Press, Hold, Jiggle",
                text: "From your iPhone’s Home Screen, touch and hold a widget or an empty area of the screen until the apps start to jiggle.",
                image: Image(systemName: "scribble")
            ),
            CarouselCardContent(
                title: "2. Add a Widget",
                text: "Tap the Add button in the upper-left corner.",
                image: Image(systemName: "scribble")
            ),
            CarouselCardContent(
                title: "3. Choose an App",
                text: "Select an app to power the widget. Choose from the list provided or search for the app you’re looking for.",
                image: Image(systemName: "scribble")
            ),
            CarouselCardContent(
                title: "4. Choose a Size",
                text: "Choose you’re preffered Widget size and shape from the three available, then tap Add Widget.",
                image: Image(systemName: "scribble")
            ),
            CarouselCardContent(
                title: "5. Place & Configure",
                text: "Drag and drop your widget to place it on your home screen (you can stack widgets of the same size!). Once it's placed, tap on it again while the screen is jiggling to configure it.",
                image: Image(systemName: "scribble")
            ),
            CarouselCardContent(
                title: "6. Done!",
                text: "To move your widget, long press and drag your Widget around. Once you’re homescreen is as you want, tap done.",
                image: Image(systemName: "scribble")
            )
        ])
        
    }
}

struct TutorialSheet_Previews: PreviewProvider {
    static var previews: some View {
        TutorialSheet()
    }
}
