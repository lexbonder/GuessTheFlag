//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alex Bonder on 7/9/23.
//

import SwiftUI

struct FlagImage: View {
    let countryName: String
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        Image(countryName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .accessibilityLabel(labels[countryName, default: "Unknown flag"])
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingGameOver = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var alertMessage = ""
    @State private var roundNumber = 0
    @State private var animationAmount = 0.0
    @State private var selectedFlag = -1
    
    
    var judging: String {
        if score == 8 {
            return "Perfect! You know your countries!"
        } else if score > 4 {
            return "Well done, nearly there!"
        } else {
            return "Nice try. Keep practicing and soon you'll get them all!"
        }
    }
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countryName: countries[number])
                                .rotation3DEffect(.degrees(selectedFlag == number ? animationAmount + 360 : animationAmount), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.5)
                                .scaleEffect(selectedFlag == -1 ? 1 : selectedFlag == number ? 1.25 : 0.5)
                                .animation(selectedFlag == -1 ? nil : .default, value: selectedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert("Game Over!", isPresented: $showingGameOver) {
            Button("New Game", action: newGame)
        } message: {
            Text("""
                You got \(score) of 8 correct.

                \(judging)
            """)
        }

    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number

        if (number == correctAnswer) {
            scoreTitle = "Correct"
            score += 1
            alertMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            alertMessage = "That's the flag of \(countries[number])"
        }

        showingScore = true
        roundNumber += 1
    }
    
    func askQuestion() {
        if roundNumber == 8 {
            showingGameOver = true
            return
        }
        countries.shuffle()
        selectedFlag = -1
        correctAnswer = Int.random(in: 0...2)
    }
    
    func newGame() {
        score = 0
        roundNumber = 0
        askQuestion()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
