//
//  ContentView.swift
//  RegionTask
//
//  Created by Alexander Römer on 29.12.19.
//  Copyright © 2019 Alexander Römer. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var record = false
    @ObservedObject private var recordManager: RecordManager = RecordManager()
    @State private var isOn = false
    private let buttonSize: CGFloat = 150
    
    var body: some View {
        ZStack() {
            RadialGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray6)]), center: .center, startRadius: 5, endRadius: 500)
                VStack() {
                    Spacer()
                    Text("Tap to record your region task.").font(Font.system(.headline))
                        .padding(.bottom, 10).padding(.top, 20)
                    Text("Max record time < 1 min.").font(Font.system(.caption)).foregroundColor(Color(.systemGray))
                    .padding(.bottom, 6)

                    Text("Keep it short and clean.").font(Font.system(.caption)).foregroundColor(Color(.systemGray))
                        .padding(.bottom, 100)
                    Text(recordManager.text)
//                        .overlay(Image(systemName: "ear").scaleEffect(2).foregroundColor(Color(.systemGray)).opacity(isOn ? 0 : 1))
                        .padding(.horizontal, 24)
                        .multilineTextAlignment(.center)
                        .lineLimit(25)
                    Spacer()
                    Rectangle()
                    .fill(isOn ? Color.green : Color.red)
                    .frame(width: buttonSize, height: buttonSize)
                    .onTapGesture(count: 1, perform: {
                        self.recordManager.recordAndRecognizeSpeech()
                        self.isOn.toggle()
                    })
                    .cornerRadius(isOn ? 10 : buttonSize / 2)
                    .shadow(color: isOn ? .green : .red, radius: 30)
                     .overlay(Image(systemName: "play.fill").foregroundColor(.white).opacity(isOn ? 0 : 1))
                     .overlay(Image(systemName: "pause.fill").foregroundColor(.white).opacity(isOn ? 1 : 0))
                    .rotationEffect(.degrees(isOn ? 180 : 0))
                    .scaleEffect(isOn ? 0.7  : 1)
                    .animation(.default)
                        .padding(.bottom, 150)
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
