//
//  StaggeredGrid.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/10/22.
//

import SwiftUI

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    
    var content: (T) -> Content
    var list: [T]
    
    var columns: Int
    
    var showsIndicators: Bool
    var spacing: CGFloat
    
    init(list: [T], columns: Int, showsIndicators: Bool, spacing: CGFloat, @ViewBuilder content: @escaping (T) -> Content) {
        self.list = list
        self.columns = columns
        self.showsIndicators = showsIndicators
        self.spacing = spacing
        self.content = content
    }
    
    func setupList() -> [[T]] {
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        var currentIndex: Int = 0
        
        for object in list {
            gridArray[currentIndex].append(object)
            
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        
        return gridArray
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            HStack(alignment: .top) {
                
                ForEach(setupList(), id: \.self) { column in
                    LazyVStack(spacing: spacing) {
                        ForEach(column) { object in
                            content(object)
                        }
                    }
                }
                
                
            }
            .padding(.vertical)
        }
    }
}

struct StaggeredGrid_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
