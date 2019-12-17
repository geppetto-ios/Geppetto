//
//  SimpleAdder.swift
//  Example
//
//  Created by Kang Min Ahn on 2019/12/16.
//  Copyright © 2019 rinndash. All rights reserved.
//

import SwiftUI

var integerFormatter: NumberFormatter {
    let nf = NumberFormatter()
    nf.numberStyle = .none
    return nf
}

struct SimpleAdderView: View {
    @State var right: Decimal? = nil
    @State var left: Decimal? = nil
    var addedValue: Binding<String> {
        Binding<String>(
            get: {
                guard let left = self.left, let right = self.right else {
                    return " "
                }
                return String(NSDecimalNumber(decimal: left + right).intValue)
            },
            set: { newValue in print(newValue) }
        )
    }

    var body: some View {
        HStack {
            DecimalField(label: "L", value: $left, formatter: integerFormatter)
                .border(Color.black)
                .font(.system(size: 25))
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .leading)
            Text("+")
            DecimalField(label: "R", value: $right, formatter: integerFormatter)
                .border(Color.black)
                .font(.system(size: 25))
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .leading)
            Text("=")
            Text(addedValue.wrappedValue)
                .font(.system(size: 25))
                .border(Color.black)
        }
    }
}

struct SimpleAdderView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleAdderView()
    }
}
