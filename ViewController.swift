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

class ViewController: UIViewController 
{
    
    enum Colors : Int
    {
        case red = 1
        case pink = 2
        case green = 3
        case indigo = 4
    }
    
    // Array of colors
    let colors: [UIColor] = [.systemRed, .systemPink, .systemGreen, .systemIndigo]
    
    // Declare imageView as a class-level property
    var imageView: UIImageView!
    
    //colorPattern array
    var colorPattern: [Int] = []
    var color: Colors = .red
    
    //variables
    let buttonSizes: Int = 100
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add and configure the background image
        addBackgroundImage()
        
        // Start the spinning animation
        startSpinningAnimation()
        generateNewColor()
        //displaySequence(bkgC: colorPattern.last!)
        self.view.backgroundColor = .systemMint
        
        //view.addSubview(buttonRed)
        //view.addSubview(buttonGreen)
        //view.addSubview(buttonBlue)
        //view.addSubview(buttonYellow)
        
        //begin test area
        placeRedButton()
        placeGreenButton()
        placeBlueButton()
        placeYellowButton()
        //end test area
        
        buttonRed.addTarget(self, action: #selector(buttonRedAction), for: .touchUpInside)
        buttonGreen.addTarget(self, action: #selector(buttonGreenAction), for: .touchUpInside)
        buttonBlue.addTarget(self, action: #selector(buttonBlueAction), for: .touchUpInside)
        buttonYellow.addTarget(self, action: #selector(buttonYellowAction), for: .touchUpInside)
        
        
    }
    
    // Function to add background image
    func addBackgroundImage() 
    {
        // Create UIImageView
        imageView = UIImageView(frame: self.view.bounds)
        
        // Set the image
        imageView.image = UIImage(named: "main_circle_background")
        
        // Make sure the image maintains aspect ratio
        imageView.contentMode = .scaleAspectFit
        
        // Add the UIImageView to the view hierarchy
        self.view.addSubview(imageView)
        
        // Send the image view to the back so it doesn't cover other UI elements
        self.view.sendSubviewToBack(imageView)
    }
    
    // Function to start spinning animation
    func startSpinningAnimation() 
    {
        //chatGPT helped with this function
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 5 // Duration of one full rotation in seconds
        rotation.repeatCount = .infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    // Other game logic functions here...
    func setupGame() 
    {
        // Example setup code
    }

    func generateNewColor() 
    {
        let randomInt = Int.random(in: 0...3)
        colorPattern.append(randomInt)
    }

    func displaySequence(bkgC:Int)
    {
        switch bkgC
        {
        case 0:
            self.view.backgroundColor = .systemRed
        case 1:
            self.view.backgroundColor = .systemPink
        case 2:
            self.view.backgroundColor = .systemGreen
        case 3:
            self.view.backgroundColor = .systemIndigo
        default:
            self.view.backgroundColor = .black
        }
    }

    func lightUp(color: UIColor) 
    {
        // Example function
    }

    @IBAction func colorButtonTapped(_ sender: UIButton) 
    {
        // Example function
    }

    func checkSequence() 
    {
        // Example function
    }

    func gameOver() 
    {
        // Example function
    }

    func resetGame() 
    {
        // Example function
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
    }
    
    func placeRedButton() -> Void
    {
        let imageRedCircle = UIImage(named: "red_circle")
        let imageView = UIImageView(image: imageRedCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 210, y: 460, width: buttonSizes, height: buttonSizes) // example frame
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
    }
    
    func placeGreenButton() -> Void
    {
        let imageGreenCircle = UIImage(named: "green_circle")
        let imageView = UIImageView(image: imageGreenCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 110, y: 460, width: buttonSizes, height: buttonSizes) // example frame
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
    }
    
    func placeBlueButton() -> Void
    {
        let imageBlueCircle = UIImage(named: "blue_circle")
        let imageView = UIImageView(image: imageBlueCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 210, y: 370, width: buttonSizes, height: buttonSizes) // example frame
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
    }
    
    func placeYellowButton() -> Void
    {
        let imageYellowCircle = UIImage(named: "yellow_circle")
        let imageView = UIImageView(image: imageYellowCircle)
        imageView.isUserInteractionEnabled = true // UIImageView is not interactive by default
        imageView.frame = CGRect(x: 110, y: 370, width: buttonSizes, height: buttonSizes) // example frame
        view.addSubview(imageView)
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonYellowAction))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
}
