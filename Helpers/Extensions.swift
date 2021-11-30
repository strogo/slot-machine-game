//
//  Extensions.swift
//  Slot Machine
//
//  Created by AYDIN EREN KESKİN on 29.11.2021.
//

import SwiftUI

extension Text{
    func scoreLabelStyle()->Text{
        self
            .foregroundColor(Color.white)
            .font(.system(size: 10, weight: .bold,design: .rounded))
    }
    
    func scoreNumberStyle()-> Text{
        self
            .foregroundColor(Color.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
    }
}
