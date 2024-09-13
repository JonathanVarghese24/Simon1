//
//  ContentView.swift
//  Simon1
//
//  Created by Jonathan V on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var colorDisplay = [ColorDisplay(color: .green),
                                       ColorDisplay(color: .red),
                                       ColorDisplay(color: .yellow),
                                       ColorDisplay(color: .blue)]
    
    var body: some View {
        ZStack {
            VStack {
                Text("Simon")
                    .font(.system(size: 45))
            }
            VStack {
                HStack {
                    colorDisplay[0]
                    colorDisplay[1]
                }
                HStack {
                    colorDisplay[2]
                    colorDisplay[3]
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ColorDisplay: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(color)
            .frame(width: 100, height: 100, alignment: .center)
            .padding()
    }
    
}

#Preview {
    ContentView()
}
