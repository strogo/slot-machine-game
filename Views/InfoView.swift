//
//  InfoView.swift
//  Slot Machine
//
//  Created by AYDIN EREN KESKİN on 29.11.2021.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
          LogoView()
            Spacer()
            
            Form{
                Section(header: Text("About the application")){
                    
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platform", secondItem: "iPhone,iPad,Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Aek")
                    FormRowView(firstItem: "Designer", secondItem: "Eren Design")
                    FormRowView(firstItem: "Music", secondItem: "Dan lobowitz")
                    FormRowView(firstItem: "Website", secondItem: "aydinerenkeskin.com")
                    FormRowView(firstItem: "Copyright", secondItem: "© 2021 All Right Reserved")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                    
                }
                
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top,40)
        .overlay(
            Button(action: {
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
                        }
                  )
                .padding(.top,20)
                .padding(.trailing,20)
                .accentColor(Color.secondary)
            
            ,alignment: .topTrailing
        )
        .onAppear {
            playSound(sound: "background-music", type: "mp3")
        }
    }
}


struct FormRowView: View {
    var firstItem : String
    var secondItem : String
    var body: some View {
        HStack{
            Text(firstItem).foregroundColor(Color.gray)
            Spacer()
            Text(secondItem)
        }
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


