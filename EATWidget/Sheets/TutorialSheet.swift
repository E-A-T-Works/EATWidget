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
                    title: "1. Edit your home screen",
                    text: "Start by going to your home screen and long pressing on it until everything starts jiggling.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-00",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "2. Add a Widget",
                    text: "Press the '+' in the upper left corner.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-01",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "3. Select e∙a∙t∙}",
                    text: "You'll need to pass a bunch of other options here - scroll all the way to the bottom and choose e∙a∙t∙}",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-02",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "4. Pick a template",
                    text: "Swiping left and right, you'll see a few widget size options. Pick the one you like, and press 'Add Widget'.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-03",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "5. Choose your NFT",
                    text: "You made a widget, but now you need to select your art. Tap your new widget to choose your NFT. Rinse and repeat for each widget you create.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-04",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "6. Customize",
                    text: "While they are still jiggling, drag your widgets around your home screen until it looks just how you want it.  Et viola! You're done.",
                    animationUrl: Bundle.main.url(
                        forResource: "tutorial-05",
                        withExtension: "MOV"
                    )!
                ),
                CarouselCardContent(
                    title: "7. Extra Credit",
                    text: "Wanna turn your widget into an NFT gallery? Stack widgets of the same size on top of each other to make a gallery you can scroll through.",
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
