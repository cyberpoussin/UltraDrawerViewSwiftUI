//
//  SwiftUIView.swift
//  UltraDrawerViewSwiftUI
//
//  Created by Admin on 18/03/2021.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var offset = CGFloat.zero
    var body: some View {
        ScrollView {
            VStack {
                Text(offset.description)
                ForEach(0..<100) { i in
                    Text("Item \(i)").padding()
                }
            }.background(GeometryReader {
                Color.clear.preference(key: ViewOffsetKey.self,
                    value: -$0.frame(in: .named("scroll")).origin.y)
            })
            .onPreferenceChange(ViewOffsetKey.self) {
                offset = $0
                
            }
        }.coordinateSpace(name: "scroll")
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
