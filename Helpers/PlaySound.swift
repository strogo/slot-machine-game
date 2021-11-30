//
//  PlaySound.swift
//  Slot Machine
//
//  Created by AYDIN EREN KESKİN on 30.11.2021.
//

import AVFoundation

var audioPlayer : AVAudioPlayer?

func playSound(sound: String, type: String)
{
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
            
        }catch{
            print("ERROR : Could not find and play sound file")
        }
    }
}
