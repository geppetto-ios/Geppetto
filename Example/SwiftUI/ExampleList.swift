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
    let swiftUIImage = Image("swiftui-24")
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SimpleAdderView()) {
                    Text("Simple Adder")
                    swiftUIImage
                }
                NavigationLink(destination: SimpleAdderView()) {
                    Text("Persistent Adder")
                    swiftUIImage
                }
                NavigationLink(destination: SimpleAdderView()) {
                    Text("Networking Adder")
                    swiftUIImage
                }
                NavigationLink(destination: SimpleAdderView()) {
                    Text("Error Handling Adder")
                    swiftUIImage
                }
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
