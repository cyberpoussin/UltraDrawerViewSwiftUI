//
//  ContentView.swift
//  UltraDrawerViewSwiftUI
//
//  Created by Admin on 18/03/2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var orientationManager = DeviceOrientation()
    @State var height: CGFloat = 0
    @State var show = false
    var body: some View {
        ZStack {
            Color.clear
                
                  
            GeometryReader { proxy in
            DrawerViewRepresentable {
                GeometryReader { proxy2 in
                Text("\(proxy2.frame(in: .global).origin.y - proxy.frame(in: .global).origin.y)")
                }
                
            } content: {
               
                LolView()
                    .frame(width: UIScreen.main.bounds.width)
                
            }
            }
            .padding(.horizontal, 10)
            //.padding(.trailing, orientationManager.orientation == .landscape ? 0 : 0)
            .coordinateSpace(name: "scroll")

            
            //.padding(.trailing, 100)
            
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct LolView: View {
    @State var offset: CGFloat = 0
    @State var shown = false
    var body: some View {
        VStack {
            //Text(offset.description)
            ForEach(0..<5) { i in
                Text("Item Item Item Item Item Item Item Item Item Item Item Item Item Item Item Item Item Item Item Item\(i)").padding()
            }
            Button("show") {
                shown.toggle()
            }
            if shown {
                ForEach(0..<100) { i in
                    Text("Item Item Item Item Item Item Item Item Item Item \(i)").padding()
                }
            } else {
                ForEach(0..<3) { i in
                    Text("Item \(i)").padding()
                }
            }
            ForEach(0..<100) { i in
                Text("Item Item Item Item Item Item Item Item Item Item \(i)").padding()
            }
        }
//        .background(GeometryReader {
//            Color.clear.preference(key: ViewOffsetKey.self,
//                                   value: -$0.frame(in: .named("scroll")).origin.y)
//        })
//        .onPreferenceChange(ViewOffsetKey.self) {
//            offset = $0
//            
//        }
    }
}
