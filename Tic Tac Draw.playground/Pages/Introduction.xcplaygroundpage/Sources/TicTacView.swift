//
//  TicTacView.swift
//  TicTacDraw
//
//  Created by Swupnil Sahai on 03/31/18.
//  Copyright © 2018 Swupnil Sahai. All rights reserved.
//

import UIKit

class TicTacView: UIView {
    
    // MARK: Properties
    
    public var currentPlayer: TicTacPlayer = .host
    
    private var didInitConstraints = false
    private var hostSelectedPositions = [Int]()
    private var guestSelectedPositions = [Int]()
    
    // MARK: UI Elements
    
    private var labels = [UILabel]()
    private var lineViews = [UIView]()
    
    // MARK: View Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews() {
        initLabels()
        initLineViews()
    }
    
    func initLabels() {
        for i in 1...9 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(i)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 40)
            labels.append(label)
            addSubview(label)
        }
    }
    
    func initLineViews() {
        for _ in 0..<4 {
            let lineView = UIView()
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.backgroundColor = UIColor.black
            lineViews.append(lineView)
            addSubview(lineView)
        }
    }
    
    // MARK: Constaints Initialization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLabels()
        layoutLineViews()
    }
    
    /// Initializes the labels' constraints.
    func layoutLabels() {
        for i in 0..<3 {
            for j in 0..<3 {
                let label = labels[i*3 + j]
                label.frame.origin.y = CGFloat(i)/3.0 * frame.size.height
                label.frame.origin.x = CGFloat(j)/3.0 * frame.size.width
                label.frame.size.height = frame.size.height/3.0
                label.frame.size.width = frame.size.width/3.0
                
                /// Update the label value for this position.
                let index = i*3 + j + 1
                if hostSelectedPositions.contains(index) {
                    label.text = TicTacPlayer.host.toString
                    label.alpha = 1.0
                }
                else if guestSelectedPositions.contains(index) {
                    label.text = TicTacPlayer.guest.toString
                    label.alpha = 1.0
                }
                else {
                    label.text = "\(index)"
                    label.alpha = 0.5
                }
            }
        }
    }
    
    /// Initializes the line views' constraints.
    func layoutLineViews() {
        for i in 0..<2 {
            let view = lineViews[i]
            view.frame.origin.y = 0.0
            view.frame.origin.x = CGFloat(i+1)/3.0 * frame.size.width
            view.frame.size.height = frame.size.height
            view.frame.size.width = 1.0
        }
        for i in 2..<4 {
            let view = lineViews[i]
            view.frame.origin.y = CGFloat(i%2+1)/3.0 * frame.size.height
            view.frame.origin.x = 0.0
            view.frame.size.height = 1.0
            view.frame.size.width = frame.size.width
        }
    }
    
    // MARK: View Updating
    
    /// Resets the selected values.
    public func resetBoard() {
        guestSelectedPositions.removeAll()
        hostSelectedPositions.removeAll()
        setNeedsLayout()
    }
    
    /// Updates the x value.
    private func addX(at position: Int) -> Bool {
        if !guestSelectedPositions.contains(position) {
            hostSelectedPositions.append(position)
            setNeedsLayout()
            switchPlayer()
            return true
        }
        return false
    }
    
    /// Updates the o value.
    private func addO(at position: Int) -> Bool {
        if !hostSelectedPositions.contains(position) {
            guestSelectedPositions.append(position)
            setNeedsLayout()
            switchPlayer()
            return true
        }
        return false
    }
    
    // MARK: Game Updating
    
    /// Makes a move at the specified position.
    public func makeMove(at position: Int) -> Bool {
        
        if let _ = winner { return false }
        
        if (position > 0) && (position <= 9) {
            if currentPlayer.isHost {
                return addX(at: position)
            }
            else {
                return addO(at: position)
            }
        }
        return false
    }
    
    /// Undoes the last move.
    public func undoLastMove() {
        if started {
            if currentPlayer.isHost {
                guestSelectedPositions.removeLast()
            }
            else {
                hostSelectedPositions.removeLast()
            }
            setNeedsLayout()
            switchPlayer()
        }
    }
    
    /// Switches the current player from host to guest, or vice versa.
    private func switchPlayer() {
        switch currentPlayer {
        case .host:
            currentPlayer = .guest
        case .guest:
            currentPlayer = .host
        }
    }
    
    // MARK: Condition Checking
    
    /// Computes and returns a winner of the current game, if one exists.
    public var winner: TicTacPlayer? {
        if isWinner(vals: hostSelectedPositions) {
            return .host
        }
        else if isWinner(vals: guestSelectedPositions) {
            return .guest
        }
        return nil
    }
    
    /// Returns whether the set of selected positions is a winner.
    private func isWinner(vals: [Int]) -> Bool {
        
        let firstRow = [1,2,3]
        let secondRow = [4,5,6]
        let thirdRow = [7,8,9]
        let firstCol = [1,4,7]
        let secondCol = [2,5,8]
        let thirdCol = [3,6,9]
        let leftDiag = [1,5,9]
        let rightDiag = [3,5,7]
        
        return vals.contains(array: firstRow) ||
            vals.contains(array: secondRow) ||
            vals.contains(array: thirdRow) ||
            vals.contains(array: firstCol) ||
            vals.contains(array: secondCol) ||
            vals.contains(array: thirdCol) ||
            vals.contains(array: leftDiag) ||
            vals.contains(array: rightDiag)
    }
    
    /// Returns whether the game has started.
    var started: Bool {
        return !(hostSelectedPositions.isEmpty && guestSelectedPositions.isEmpty)
    }
    
}

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
