//
//  ContentView.swift
//  Slot Machine
//
//  Created by AYDIN EREN KESKİN on 29.11.2021.
//

import SwiftUI

struct ContentView: View {
    
   
    
    let symbols = ["gfx-bell","gfx-cherry","gfx-coin","gfx-grape","gfx-seven","gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    @State private var highscore : Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins : Int = 100
    @State private var betAmount : Int = 10
    @State private var reels: Array = [0,1,2]
    @State private var showInfoView : Bool = false
    @State private var isActiveBet10 : Bool = true
    @State private var isActiveBet20 : Bool = false
    @State private var showingModal : Bool = false
    @State private var animatingSymbol : Bool = false
    @State private var animatingModal : Bool = false
    
    func spinReels(){
        //reels[0] = Int.random(in: 0...symbols.count-1)
        //reels[1] = Int.random(in: 0...symbols.count-1)
        //reels[2] = Int.random(in: 0...symbols.count-1)
        reels = reels.map({_ in
            Int.random(in: 0...symbols.count-1)
            
        })
        
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func checkWinning(){
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2]{
            playerWins()
            
            if(coins > highscore){
                newHighScore()
            }else{
                playSound(sound: "win", type: "mp3")
            }
            
        }
        else {
            playerLoses()
        }
    }
    
    func playerWins(){
        coins += betAmount * 10
    }
    
    func newHighScore(){
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses(){
        coins -= betAmount
    }
    
    func activeBet20(){
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    func activeBet10(){
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func isGameOver(){
        if coins <= 0 {
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activeBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"),Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 5) {
               LogoView()
               Spacer()
                
                HStack {
                    HStack{
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                          
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack{
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                          
                    }
                    .modifier(ScoreContainerModifier())
                }
                VStack(alignment: .center, spacing: 0) {
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : 50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear {
                                self.animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }
               
                    
                    HStack(alignment: .center, spacing: 0) {
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : 50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .onAppear {
                                    self.animatingSymbol.toggle()
                                }
                        }
                        Spacer()
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : 50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear {
                                    self.animatingSymbol.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    Button(action: {
                        
                        withAnimation {
                            self.animatingSymbol = false
                        }
                        
                        self.spinReels()
                        
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        
                        self.checkWinning()
                        
                        self.isGameOver()
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                }
                .layoutPriority(2)
                
                
                Spacer()
                
                HStack{
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            self.activeBet20()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        })
                            .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        Button(action: {self.activeBet10()}, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color.yellow : Color.white)
                                .modifier(BetNumberModifier())
                        })
                            .modifier(BetCapsuleModifier())
                        
                       
                    }
                }
            }
            .overlay(
                Button(action: {
                    self.resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                    .modifier(ButtonModifier())
                    ,alignment: .topLeading
                    
            )
            .overlay(
                Button(action: {
                    self.showInfoView = true;
                }, label: {
                    Image(systemName: "info.circle")
                })
                    .modifier(ButtonModifier())
                    ,alignment: .topTrailing
                
                
            
            )
            .padding()
            .frame(maxWidth:720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0,opaque: false)
            
            
            if($showingModal.wrappedValue){
                ZStack{
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    VStack(spacing: 0) {
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth:0,maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 15) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight:72)
                            Text("Bad Luck You lost all of coins \n Lets play again")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            Button(action: {
                                self.showingModal = false
                                self.animatingModal = false
                                self.activeBet10()
                                self.coins = 100
                            }, label: {
                                Text("New game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal,12)
                                    .padding(.vertical,6)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            })
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y:$animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear {
                        self.animatingModal = true
                    }
                    
                }
            }
        }
        .sheet(isPresented: $showInfoView) {
            InfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
