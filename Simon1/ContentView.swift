//
//  ContentView.swift
//  Simon1
//
//  Created by Jonathan V on 9/13/24.
//
import SwiftUI

struct ContentView: View {
    @State private var colorDisplay = [Color.green, Color.red, Color.yellow, Color.blue]
    @State private var flashingColor: Int? = nil
    @State private var sequence: [Int] = []
    @State private var playerSequence: [Int] = []
    @State private var score = 0
    @State private var isPlaying = false
    @State private var showGameOver = false
    @State private var isShowingSequence = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                Text("Simon")
                    .font(.system(size: 70))
                Spacer()
            }
            VStack {
                HStack {
                    ColorDisplay(color: colorDisplay[0], isFlashing: flashingColor == 0)
                        .onTapGesture { playerTap(0) }
                    ColorDisplay(color: colorDisplay[1], isFlashing: flashingColor == 1)
                        .onTapGesture { playerTap(1) }
                }
                HStack {
                    ColorDisplay(color: colorDisplay[2], isFlashing: flashingColor == 2)
                        .onTapGesture { playerTap(2) }
                    ColorDisplay(color: colorDisplay[3], isFlashing: flashingColor == 3)
                        .onTapGesture { playerTap(3) }
                }
            }
            VStack {
                Spacer()
                Button(isPlaying ? "Playing..." : "Start Game") { // changes simon code
                    startGame()
                }
                .buttonStyle(.bordered)
                .disabled(isPlaying || isShowingSequence) //disables play button when game is in progress
                
                Text("Score: \(score)")
                    .font(.system(size: 55)) //score
            }
        }
        .preferredColorScheme(.dark)
        .alert("Game Over", isPresented: $showGameOver) {
            Button("Play Again", action: startGame)
        } message: {
            Text("Your final score was \(score)") //alert to show end score
        }
    }
    
    func startGame() {
        sequence = []
        playerSequence = []
        score = 0
        isPlaying = true
        addToSequence()
    }
    
    func addToSequence() {
        let newColor = Int.random(in: 0...3)
        sequence.append(newColor)
        playSequence()
    }
    
    func playSequence() {
        isShowingSequence = true
        flashingColor = nil
        
        Task {
            for color in sequence {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                flashColor(color)
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                flashingColor = nil
            }
            isShowingSequence = false
        }
    }
    
    func flashColor(_ index: Int) {
        flashingColor = index
    }
    
    func playerTap(_ index: Int) {
        guard isPlaying && !isShowingSequence else { return }
        
        playerSequence.append(index)
        flashColor(index)
        
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 second flash
            flashingColor = nil
            
            if !checkPlayerInput() {
                gameOver()
            } else if playerSequence.count == sequence.count {
                score += 1
                playerSequence = []
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                addToSequence()
            }
        }
    }
    
    func checkPlayerInput() -> Bool {
        return playerSequence.elementsEqual(sequence.prefix(playerSequence.count))
    }
    
    func gameOver() {
        isPlaying = false
        showGameOver = true
    }
}

struct ColorDisplay: View {
    let color: Color
    let isFlashing: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(color)
            .frame(width: 100, height: 100)
            .padding()
            .opacity(isFlashing ? 1 : 0.4)
    }
}

#Preview {
    ContentView()
}
