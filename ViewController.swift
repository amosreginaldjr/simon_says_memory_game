//
//  ViewController.swift
//  simon_says_memory_game
//
//  Created by Amos Reginald Jr. on 6/1/24.
//

/*
 what is the goal of the game:
 1) there will be 4 colors
 2) the system will randomly select a color
 then the color will light up
 the user then must press that color
 if the user press is correct, then the system REPEATS the previous color(s) and then adds a new color on
 3) for each guess that the user gets correct, then they will get a point
 NOTE: the game is semi infinite, meaning that if the user can keep up and keep the game going, then they will continue on forever
 
 Optional features:
 1) allow the user to speed up and slow down the order that the colors are displayed (this is a fair setting as users have different disabilites as others. for me it is easier to see the colors rapidly, but for others, they may need time to process how long in between each color)
 2) Add difficulties, where you start the game off with 2,3,4,5 colors and each turn adds 2,3,4,5 colors at a time
 3) add in custom user settings: the user can fine tume the game to make it as enjoyable as possible. all scores are held local anyway
 
 User customization:
 1) the user should be allowed to select different colors and put them into any slot necessary. example:
 +-------+-------+
 |  RED  | GREEN |
 +-------+-------+
 | BLUE  | YELLOW|
 +-------+-------+
 to this----------->
 +----------+----------+
 |   ORANGE |  PURPLE  |
 +----------+----------+
 |   CYAN   | MAGENTA  |
 +----------+----------+
 2) there should be accessablity features for instead of colors, we can use textures
 2.1) add in the ability for the user to select from color blind modes
 */

import UIKit
import AVFoundation
import Dispatch

class ViewController: UIViewController
{
    enum Colors : Int
    {
        case red = 1
        case green = 2
        case blue = 3
        case yellow = 4
    }
    
    // Array of colors
    let colors: [UIColor] = [.systemRed, .systemPink, .systemGreen, .systemIndigo]
    
    // Declare imageView as a class-level property
    var imageView: UIImageView? //previously was 'UIImageView!'
    
    
    //colorPattern array
    var colorPattern: [Int] = []
    var color: Colors = .red
    
    //variables
    let buttonSizes: Int = 100
    var currentButtonPressed: Int?
    var pattern: [Int] = []
    var currentSequenceElement: [Int] = []
    var showSequence: [Int] = []
    var currentIndex: Int = 0
    var brainImageViews: [UIImageView] = []
    var wrongInputImageViews: [UIImageView] = []
    let audioManager = AudioManager()
    //counters
    var couldWinCounter: Int = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pattern = generateSequence()
        currentSequenceElement = pattern
        showSequence = pattern
        
        // Add and configure the background image
        addBackgroundImage()
        
        // Start the spinning animation
        startSpinningAnimation()
        
        self.view.backgroundColor = .systemMint
        
        placeRedButton()
        placeGreenButton()
        placeBlueButton()
        placeYellowButton()
        placeResetButton()
        placePlayButton()
        
        //playToyButtonSound
        
        buttonRed.addTarget(self, action: #selector(buttonRedAction), for: .touchUpInside)
        buttonGreen.addTarget(self, action: #selector(buttonGreenAction), for: .touchUpInside)
        buttonBlue.addTarget(self, action: #selector(buttonBlueAction), for: .touchUpInside)
        buttonYellow.addTarget(self, action: #selector(buttonYellowAction), for: .touchUpInside)
        buttonRestart.addTarget(self, action: #selector(buttonResetAction), for: .touchUpInside)
        buttonPlay.addTarget(self, action: #selector(buttonPlayAction), for: .touchUpInside)
        
        lightUp()
    }
    
    //show when you get the pattern right
    func createBrainEmojiImage() -> UIImage 
    {
        // Create a UILabel to hold the emoji
        let label = UILabel()
        label.text = "🧠"
        label.font = UIFont.systemFont(ofSize: 200)  // Adjust size as needed
        label.sizeToFit()
        
        // Render the label into a UIImage
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func placeBrain(at position: CGPoint) 
    {
        let brainImage = createBrainEmojiImage()
        let imageView = UIImageView(image: brainImage)
        imageView.frame = CGRect(origin: position, size: CGSize(width: 50, height: 50))
        self.view.addSubview(imageView)
        brainImageViews.append(imageView)
    }
    
    func placeBrain1() 
    {
        placeBrain(at: CGPoint(x: 30, y: 750))
    }
    
    func placeBrain2()
    {
        placeBrain(at: CGPoint(x: 100, y: 750))
    }
    
    func placeBrain3()
    {
        placeBrain(at: CGPoint(x: 170, y: 750))
    }
    
    func placeBrain4()
    {
        placeBrain(at: CGPoint(x: 240, y: 750))
    }
    
    func placeBrain5()
    {
        placeBrain(at: CGPoint(x: 310, y: 750))
    }
    
    func cleanupBrains()
    {
        for imageView in brainImageViews
        {
            imageView.removeFromSuperview()
        }
        brainImageViews.removeAll()
    }
    
    //handle if the user gets the pattern wrong
    
    //wrong emoji
    func createWrongEmojiImage() -> UIImage
    {
        // Create a UILabel to hold the emoji
        let label = UILabel()
        label.text = "❌"
        label.font = UIFont.systemFont(ofSize: 200)  // Adjust size as needed
        label.sizeToFit()
        
        // Render the label into a UIImage
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func placeWrongInput(at position: CGPoint) //previously 'placeErrorBrain()'
    {
        let xImage = createWrongEmojiImage()
        let imageView = UIImageView(image: xImage)
        imageView.frame = CGRect(origin: position, size: CGSize(width: 50, height: 50))
        self.view.addSubview(imageView)
        wrongInputImageViews.append(imageView)
    }
    
    func placeWrongInput1()
    {
        placeWrongInput(at: CGPoint(x: 30, y: 750))
    }
    
    func placeWrongInput2()
    {
        placeWrongInput(at: CGPoint(x: 100, y: 750))
    }
    
    func placeWrongInput3()
    {
        placeWrongInput(at: CGPoint(x: 170, y: 750))
    }
    
    func placeWrongInput4()
    {
        placeWrongInput(at: CGPoint(x: 240, y: 750))
    }
    
    func placeWrongInput5()
    {
        placeWrongInput(at: CGPoint(x: 310, y: 750))
    }
    
    func cleanupWrongInput()
    {
        for imageView in wrongInputImageViews
        {
            imageView.removeFromSuperview()
        }
        wrongInputImageViews.removeAll()
    }
    
    // Function to add background image
    func addBackgroundImage()
    {
        // Create UIImageView
        imageView = UIImageView(frame: self.view.bounds)
        
        // Set the image
        imageView?.image = UIImage(named: "main_circle_background")
        
        // Make sure the image maintains aspect ratio
        imageView?.contentMode = .scaleAspectFit
        
        // Add the UIImageView to the view hierarchy
        if let imageView = imageView 
        {
            self.view.addSubview(imageView)
        // Send the image view to the back so it doesn't cover other UI elements
            self.view.sendSubviewToBack(imageView)
        }
    }
    
    //remove the background image
    func removeBackgroundImage()
    {
        imageView?.removeFromSuperview()
        imageView = nil
    }
    
    // Function to start spinning animation
    func startSpinningAnimation()
    {
        guard let imageView = imageView else { return }
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 5 // Duration of one full rotation in seconds
        rotation.repeatCount = .infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }

    func generateSequence() -> [Int]
    {
        let numberArray = (0..<5).map{ _ in Int.random(in: 0 ... 3) }
        for int in numberArray
        {
            print(int, terminator: " ")
        }
        print("\n")
        return numberArray
    }

    func lightUp()
    {
        for (index, val) in currentSequenceElement.enumerated()
        {
            // Flash gray before the actual color
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2.0)
//            {
//                self.view.backgroundColor = .black
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0)
            {
                switch val
                {
                    case 0:
                        self.view.backgroundColor = .red
                    case 1:
                        self.view.backgroundColor = .green
                    case 2:
                        self.view.backgroundColor = .blue
                    case 3:
                        self.view.backgroundColor = .yellow
                    default:
                        self.view.backgroundColor = .gray
                }
            }
        }
    }

    func checkButtonPress() -> Int?
    {
        guard let currentButtonPressed = currentButtonPressed else { return nil }
        return currentButtonPressed
    }

    func checkSequence()
    {
        
        guard let currentButtonPressed = currentButtonPressed else { return }
            
        if currentButtonPressed == currentSequenceElement[currentIndex]
        {
            self.couldWinCounter += 1
            switch currentIndex
            {
                case 0:
                    placeBrain1()
                case 1:
                    placeBrain2()
                case 2:
                    placeBrain3()
                case 3:
                    placeBrain4()
                case 4:
                    placeBrain5()
                default:
                    print("error: 112")
            }
                
            currentIndex += 1
                
                if currentIndex < showSequence.count 
            {
                // Proceed to the next element in the sequence
                print(showSequence[currentIndex], terminator: " ")
            } 
            else
            {
                print("Sequence completed.")
                // Optionally, you can add any additional logic here for when the sequence is completed.
            }
        }
        else
        {
            // Handle incorrect button press (e.g., reset the game, show an error, etc.)
            audioManager.playGuessWrongSound()
            switch currentIndex
            {
                case 0:
                    placeWrongInput1()
                case 1:
                    placeWrongInput2()
                case 2:
                    placeWrongInput3()
                case 3:
                    placeWrongInput4()
                case 4:
                    placeWrongInput5()
                default:
                    print("error: 112")
            }
            currentIndex += 1
            print("Incorrect button pressed.")
            print("CurrenIndex: ", currentIndex)
        }
        
        if currentIndex == 5
        {
            gameOver()
        }
    }

    func gameOver()
    {
        //either put confetti and play a win sound or tell the user that they lost and play a womp womp sound
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds)
//        {
//            if self.couldWinCounter == 5 { self.audioManager.playHomeRunSound() }
//            else { self.audioManager.playGameOverSound() }
//        }
        
        if self.couldWinCounter == 5
        {
            DispatchQueue.main.asyncAfter(deadline: .now())
            {
                self.audioManager.playHomeRunSound()
            }
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now())
            {
                self.audioManager.playGameOverSound()
            }
        }
        print("couldWinCounter: ", self.couldWinCounter)
        
        
        
        
        
        
        
        
        
        
        
        resetGame()
    }

    func resetGame()
    {
        currentSequenceElement = generateSequence()
        showSequence = currentSequenceElement
        currentIndex = 0
        lightUp()
        couldWinCounter = 0
        
        removeBackgroundImage()
        
        addBackgroundImage()
        startSpinningAnimation()
        
        cleanupBrains()
        cleanupWrongInput()
        
        //call play button here
        while currentButtonPressed != 9
        {
            //DO SOMETIHNG
        }
    }
    
    
    
    
    
    
    //Red Button
    private var buttonRed: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Red", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func buttonRedAction()
    {
        self.view.backgroundColor = .systemRed
        currentButtonPressed = 0
        checkSequence()
        audioManager.playToyButtonSound()
    }
    
    func placeRedButton() -> Void
    {
        let imageRedCircle = UIImage(named: "red_circle")
        let imageView = UIImageView(image: imageRedCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x:110, y: 370, width: buttonSizes, height: buttonSizes) // example frame
        view.addSubview(imageView)
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonRedAction))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //Green Button
    private let buttonGreen: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Green", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func buttonGreenAction()
    {
        self.view.backgroundColor = .systemGreen
        currentButtonPressed = 1
        checkSequence()
        audioManager.playToyButtonSound()
    }
    
    func placeGreenButton() -> Void
    {
        let imageGreenCircle = UIImage(named: "green_circle")
        let imageView = UIImageView(image: imageGreenCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 210, y: 370, width: buttonSizes, height: buttonSizes) // example frame
        view.addSubview(imageView)
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonGreenAction))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    //Blue Button
    private let buttonBlue: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Blue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func buttonBlueAction()
    {
        self.view.backgroundColor = .systemBlue
        currentButtonPressed = 2
        checkSequence()
        audioManager.playToyButtonSound()
    }
    
    func placeBlueButton() -> Void
    {
        let imageBlueCircle = UIImage(named: "blue_circle")
        let imageView = UIImageView(image: imageBlueCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 110, y: 460, width: buttonSizes, height: buttonSizes) // example frame
        view.addSubview(imageView)
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonBlueAction))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //Yellow Button
    private let buttonYellow: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitle("Yellow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func buttonYellowAction()
    {
        self.view.backgroundColor = .systemYellow
        currentButtonPressed = 3
        checkSequence()
        audioManager.playToyButtonSound()
    }
    
    func placeYellowButton() -> Void
    {
        let imageYellowCircle = UIImage(named: "yellow_circle")
        let imageView = UIImageView(image: imageYellowCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 210, y: 460, width: buttonSizes, height: buttonSizes) // example frame
        view.addSubview(imageView)
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonYellowAction))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //reset button
    private let buttonRestart: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func buttonResetAction()
    {
        self.view.backgroundColor = .systemGray
        resetGame()
        audioManager.playRestartSound()
    }
    
    func placeResetButton() -> Void 
    {
        let imageResetCircle = UIImage(named: "reset_button")
        let imageView = UIImageView(image: imageResetCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 50, y: 800, width: buttonSizes, height: buttonSizes) // example frame
        view.addSubview(imageView)
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonResetAction))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        }
    
    
    //play button
    private let buttonPlay: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func buttonPlayAction()
    {
        self.view.backgroundColor = .systemGray
        //resetGame() //should pressing play also reset the game?
        currentButtonPressed = 9
        audioManager.playRestartSound()
    }
    
    func placePlayButton() -> Void
    {
        let imagePlayCircle = UIImage(named: "play_button")
        let imageView = UIImageView(image: imagePlayCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 200, y: 800, width: buttonSizes, height: buttonSizes) // example frame
        view.addSubview(imageView)
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonPlayAction))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
