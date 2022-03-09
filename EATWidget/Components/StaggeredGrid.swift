//
//  StaggeredGrid.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/10/22.
//

import SwiftUI

struct StaggeredGridColumn<T>: Identifiable {
    let id: Int
    var elements: [T]
}

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    
    var content: (T) -> Content
    var list: [T]
    
    var columns: Int
    
    var showsIndicators: Bool
    var spacing: CGFloat
    
    let lazy: Bool
    
    init(
        list: [T],
        columns: Int,
        showsIndicators: Bool,
        spacing: CGFloat,
        lazy: Bool,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.list = list
        self.columns = columns
        self.showsIndicators = showsIndicators
        self.spacing = spacing
        self.lazy = lazy
        self.content = content
    }
    
    func setupColumns() -> [StaggeredGridColumn<T>] {
        var columnArray: [StaggeredGridColumn] = (0...columns - 1).map { StaggeredGridColumn<T>(id: $0, elements: []) }
        
        var currentIndex: Int = 0
        
        for object in list {
            columnArray[currentIndex].elements.append(object)
            
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        
        return columnArray
    }
    
    var body: some View {
        
        HStack(alignment: .top) {
            ForEach(setupColumns()) { column in
                
                if lazy {
                    LazyVStack(spacing: spacing) {
                        ForEach(column.elements) { object in
                            content(object)
                        }
                    }
                } else {
                    VStack(spacing: spacing) {
                        ForEach(column.elements) { object in
                            content(object)
                        }
                    }
                }
            }
        }
        .padding(.vertical)
    
    }
}

struct StaggeredGrid_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
