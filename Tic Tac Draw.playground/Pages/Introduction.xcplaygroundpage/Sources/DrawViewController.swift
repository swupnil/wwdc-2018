//
//  DrawViewController.swift
//  TicTacDraw
//
//  Created by Swupnil Sahai on 03/31/18.
//  Copyright © 2018 Swupnil Sahai. All rights reserved.
//

import UIKit

public class DrawViewController: UIViewController, DrawViewDelegate {
    
    // MARK: Private Properties
    
    private let drawView: DrawView = {
        let drawView = DrawView()
        drawView.translatesAutoresizingMaskIntoConstraints = false
        return drawView
    }()
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .center
        headerLabel.text = "👇 Player \(TicTacPlayer.host.toString)'s Turn 👇"
        headerLabel.textColor = UIColor.black
        return headerLabel
    }()
    private let undoButton: UIButton = {
        let undoButton = UIButton(type: .system)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.layer.cornerRadius = 8
        undoButton.backgroundColor = UIColor(red: 179/255.0, green: 86/255.0, blue: 77/255.0, alpha: 1.0)
        undoButton.setTitleColor(UIColor.white, for: .normal)
        undoButton.setTitle("Undo", for: .normal)
        return undoButton
    }()
    private let detectButton: UIButton = {
        let detectButton = UIButton(type: .system)
        detectButton.translatesAutoresizingMaskIntoConstraints = false
        detectButton.layer.cornerRadius = 8
        detectButton.backgroundColor = UIColor(red: 35/255.0, green: 140/255.0, blue: 81/255.0, alpha: 1)
        detectButton.setTitleColor(UIColor.white, for: .normal)
        detectButton.setTitle("Detect", for: .normal)
        return detectButton
    }()
    private let lastMoveLabel: UILabel = {
        let lastMoveLabel = UILabel()
        lastMoveLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMoveLabel.textAlignment = .center
        lastMoveLabel.text = "🤔 Choose wiseley 🤔"
        return lastMoveLabel
    }()
    private let ticTacView: TicTacView = {
        let view = TicTacView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private let model: mnistCNN = {
        return mnistCNN()
    }()
    
    // MARK: View Initialization
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tic Tac Draw"
        view.backgroundColor = #colorLiteral(red: 0.9646043181, green: 0.9647660851, blue: 0.9645816684, alpha: 1)
        
        initHeaderLabel()
        initDrawView()
        initButtons()
        initTicTacView()
        updateFromDrawing()
    }
    
    /// Initializes the header label.
    private func initHeaderLabel() {
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    /// Intializes the draw view.
    private func initDrawView() {
        view.addSubview(drawView)
        drawView.delegate = self
        NSLayoutConstraint.activate([
            drawView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            drawView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drawView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            drawView.heightAnchor.constraint(equalTo: drawView.widthAnchor)
            ])
    }
    
    /// Initializes the reset and detect buttons.
    private func initButtons() {
        /// Initialize the undo button.
        undoButton.addTarget(self, action: #selector(clearDrawingView), for: .touchUpInside)
        view.addSubview(undoButton)
        NSLayoutConstraint.activate([
            undoButton.leftAnchor.constraint(equalTo: drawView.leftAnchor),
            undoButton.topAnchor.constraint(equalTo: drawView.bottomAnchor, constant: 8),
            undoButton.widthAnchor.constraint(equalTo: drawView.widthAnchor, multiplier: 0.5, constant: -4)
            ])
        
        /// Initialize the detect button.
        detectButton.addTarget(self, action: #selector(predictNumber), for: .touchUpInside)
        view.addSubview(detectButton)
        NSLayoutConstraint.activate([
            detectButton.rightAnchor.constraint(equalTo: drawView.rightAnchor),
            detectButton.topAnchor.constraint(equalTo: drawView.bottomAnchor, constant: 8),
            detectButton.widthAnchor.constraint(equalTo: drawView.widthAnchor, multiplier: 0.5, constant: -4)
            ])
    }
    
    /// Initializes the tic tac toe view.
    private func initTicTacView() {
        /// Initializes the label to describe the last move.describe
        view.addSubview(lastMoveLabel)
        NSLayoutConstraint.activate([
            lastMoveLabel.topAnchor.constraint(equalTo: detectButton.bottomAnchor, constant: 8),
            lastMoveLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastMoveLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            lastMoveLabel.heightAnchor.constraint(equalToConstant: 32)
            ])
        
        /// Initializes the tic tac toe board.
        view.addSubview(ticTacView)
        NSLayoutConstraint.activate([
            ticTacView.topAnchor.constraint(equalTo: lastMoveLabel.bottomAnchor, constant: 8),
            ticTacView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticTacView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            ticTacView.heightAnchor.constraint(equalTo: ticTacView.widthAnchor)
            ])
        
        /// Initialize the reset button.
        let resetButton = UIButton(type: .system)
        resetButton.layer.cornerRadius = 8
        resetButton.backgroundColor = UIColor.black
        resetButton.setTitleColor(UIColor.white, for: .normal)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.centerXAnchor.constraint(equalTo: drawView.centerXAnchor),
            resetButton.widthAnchor.constraint(equalTo: detectButton.widthAnchor, constant: 8),
            resetButton.topAnchor.constraint(equalTo: ticTacView.bottomAnchor, constant: 8)
            ])
    }
    
    // MARK: Button Handling
    
    /// Clears the drawing pane.
    @objc private func clearDrawingView() {
        /// Clear the canvas if something is currently drawn.
        if !drawView.isEmpty {
            drawView.clear()
        }
        /// Otherwise undo the last move.drawView
        else {
            ticTacView.undoLastMove()
            lastMoveLabel.text = "🤔 Choose wiseley 🤔"
            updateFromDrawing()
        }
        headerLabel.text = "👇 Player \(currentPlayer.toString)'s Turn 👇"
    }
    
    /// Makes a prediction of the number and places the next move in that frame.
    @objc private func predictNumber() {
        let context = drawView.getViewContext()
        if let inputImage = context?.makeImage(),
           let pixelBuffer = UIImage(cgImage: inputImage).pixelBuffer() {
            let output = try? model.prediction(image: pixelBuffer)
            if let label = output?.classLabel {
                if let position = Int(label) {
                    playPiece(at: position)
                }
            }
        }
    }
    
    /// Resets the game.
    @objc private func reset() {
        drawView.clear()
        ticTacView.resetBoard()
        headerLabel.text = "👇 Player \(currentPlayer.toString)'s Turn 👇"
        lastMoveLabel.text = "🤔 Choose wiseley 🤔"
    }
    
    // MARK: View Updating
    
    /// Places the tile of the next player at the specified tile number.
    public func playPiece(at position: Int) {
        let success = ticTacView.makeMove(at: position)
        if let winner = ticTacView.winner {
            headerLabel.text = "🏆🏆 Player \(winner.toString) Wins! 🏆🏆"
        }
        else if success {
            headerLabel.text = "👇 Player \(currentPlayer.toString)'s Turn 👇"
            lastMoveLabel.text = "👏 Tile \(position) Selected! 👏"
            drawView.clear()
        }
    }
    
    // MARK: Draw View DelegateChoose
    
    /// Updates the undo and detect buttons.
    public func updateFromDrawing() {
        undoButton.alpha = (drawView.isEmpty && !ticTacView.started) ? 0.5 : 1.0
        undoButton.isUserInteractionEnabled = undoButton.alpha == 1.0
        detectButton.alpha = drawView.isEmpty ? 0.5 : 1.0
        detectButton.isUserInteractionEnabled = detectButton.alpha == 1.0
        
        if drawView.isEmpty {
            undoButton.setTitle("Undo", for: .normal)
        }
        else {
            undoButton.setTitle("Clear", for: .normal)
        }
    }
    
    // MARK: Getters
    
    /// Returns the current player.
    private var currentPlayer: TicTacPlayer {
        return ticTacView.currentPlayer
    }
    
}
