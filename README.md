For my playground, I wanted to use my prior experience with Swift and combine it with my domain knowledge in machine learning, to make a fun game. I ended up creating a novel version of Tic Tac Toe, called Tic Tac Draw. Traditionally in Tic Tac Toe, players draw an “X” or “O” on the board to mark their next move. In my game, however, players take turn drawing the number of the tile (in 1,...,9) in which they want to play their next move. This is a slightly different way to play the game, but it ends up being a simple example of how machine learning can be used to make predictions. In this case, I use a hand-drawn digit recognition model to understand the digit that a player has drawn, and then I convert that into actually making a move on the board.

Since the submission is a playground, I of course used PlaygroundSupport in order to set the live view of the current PlaygroundPage. Beyond, this I vastly used UIKit, combined with programmatic NSLayoutConstraints, to instantiate and update the main view controller for my playground. I had to override the default touch handling behavior for my draw view to understand where the users were drawing on the screen. Additionally, I took advantage of Core Graphics to draw/erase the strokes that the users make on screen in real time. At the same time, I also incorporated an open source CoreML model for the hand writing detection into my playground. This was actually the trickiest part because I had to compile the model in a separate project in order to get its source stubs in .swift and its compiled model in .mlmodelc, both of which are necessary in order to use a CoreML model’s in a playground. Lastly, I created my own class to track the progression of the tic tac toe game and determine when it has ended. I ended up using Emoji to designate the player’s turns/pieces, rather than the usual “X” and “O” because it felt more fun and Swift makes it so easy to code them as strings in line. 

If I was given more time, and the appropriate APIs, I would have liked to make a playground that could be controlled by gestures on Apple Watch. For example, if I could pair my watch with iPad, the tic tac toe game could be controlled by both players wearing Apple Watches. They could virtually draw digits in the air with their hand, and a CoreML model applied to CoreMotion’s gyroscope data could be used to figure out what digit the player drew.
