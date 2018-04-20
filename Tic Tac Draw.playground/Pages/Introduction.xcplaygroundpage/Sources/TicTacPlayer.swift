//
//  TicTacPlayer.swift
//  TicTacDraw
//
//  Created by Swupnil Sahai on 03/31/18.
//  Copyright © 2018 Swupnil Sahai. All rights reserved.
//

import Foundation

// A TicTacPlayer enumrates the possible players in a game of TicTacDraw.
enum TicTacPlayer: Int {
    
    // MARK: Cases
    
    case host = 0
    case guest = 1
    
    // MARK: To String
    
    /// Returns the enum as a string.
    var toString: String {
        switch self {
        case .host:
            return "😇"
        case .guest:
            return "😈"
        }
    }
    
    // MARK: Condition Checkingcase
    
    /// Returns whether the enum is host.
    var isHost: Bool {
        return self == .host
    }
}
