import UIKit
import PlaygroundSupport
/*:
 
 ## Tic Tac Draw
 
 Tic Tac Draw is a modern twist on the classic tic tac toe. Instead of dragging pieces on the game board directly, however, you (😇) and your opponent (😈) will take turns drawing the number of the tile on which you want to play your next move.
 
 Here's how it works:
 
 
 1. Draw a digit (1,2,...,9) on the black square.
 
 2. Tap *Detect* to have a state-of-the-art neural network magically detect the digit you drew, and automatically play the tile corresponding to that digit.
 
 3. Tap *Undo* to undo the last tile placement, or clear the currently drawn number.
 
 4. Tap *Reset* to start a new game from scratch.
 
 **For the best performance, make sure the digit is centered and a reasonable size.**
 */

let drawingController = DrawViewController()
let navigationController = UINavigationController(rootViewController: drawingController)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = navigationController
