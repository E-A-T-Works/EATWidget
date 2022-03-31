//
//  TutorialSheet.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/28/22.
//

import SwiftUI

struct TutorialSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var index = 0
    
    var body: some View {
        
        ZStack {
            Carousel(list: [
                CarouselCardContent(
                    title: "1. Get Jiggy",
                    text: "Start by going to your home screen and loooooooong pressing on it until everything starts jiggling like it's 1967.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-00",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "2. Add a Widget",
                    text: "With the whole world jiggling, you'll see a button on the top left that says '+'. So what are you waiting for, press it!",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-01",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "3. Select e∙a∙t∙}",
                    text: "You'll see a bunch of things, but you know what you want. Scroll all the way to the bottom and you'll find e∙a∙t∙}. Select it to pick a widget.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-02",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "4. Pick a widget",
                    text: "Scrolling left and right, you'll see what widgets are available (we'll be adding a ton more soon). When you have the one you want focused, smash that 'Add Widget' button on the bottom.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-03",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "5. Make things pretty",
                    text: "Your widget was just dropped hot on your homescreen. While things are still jiggling, you can drag it around (maybe even stack it with another similarly-sized one too).",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-04",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "6. Set it up and boom done!",
                    text: "Once you find the perfect home for your new widget on the home screen, tap it (while it's jiggling) to set it up. Depending on the widget, you'll have a set of options that will let you make it your own!",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-05",
                        withExtension: "MOV"
                    )!
                )
            ])
            
            SheetDismissButton(
                onTapFn: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        
        
        
    }
}

struct TutorialSheet_Previews: PreviewProvider {
    static var previews: some View {
        TutorialSheet()
    }
}
