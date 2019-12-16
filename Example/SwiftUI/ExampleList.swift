//
//  ExampleList.swift
//  Example
//
//  Created by Kang Min Ahn on 2019/12/16.
//  Copyright © 2019 rinndash. All rights reserved.
//

import SwiftUI

struct ExampleList: View {
    let examples: [String] = ["Simple Adder", "Persistent Adder", "Networking Adder", "Error Handling Adder"]
    var body: some View {
        NavigationView {
          List(examples, id: \.self) { example in
            Text(example)
            Image("swiftui-24")
          }
          .navigationBarTitle("Examples")
        }
    }
}

struct ExampleList_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            ExampleList()
            .tabItem {
                Image("swiftui-24")
                Text("SwiftUI")
            }
        }
    }
}
