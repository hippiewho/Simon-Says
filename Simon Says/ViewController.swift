//
//  ViewController.swift
//  Simon Says
//
//  Created by Frank Navarrete on 12/10/17.
//  Copyright © 2017 TheHippieHop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButtons: [CircularButton]!
    @IBOutlet var scoreLabels: [UILabel]!
    @IBOutlet var playerLabels: [UILabel]!
    @IBOutlet weak var actionButton: UIButton!
    
    var currentPlayer = 0
    var scores = [0, 0]
    
    var sequenceIndex = 0
    
    var colorSequence = [Int]()
    var colorsToTap   = [Int]()

    var gameEnded = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded{
            gameEnded = false
            createNewGame()
        }
    }
    override func viewDidLoad() {
        sortLabels()
        createNewGame()
    }
    
    @IBAction func colorButtonHandler(_ sender: CircularButton) {
        if sender.tag == colorsToTap.removeFirst(){
            print("Correct")
        } else {
            for button in colorButtons {
                button.isEnabled = false
                endGame()
            }
            return
        }
        
        if colorsToTap.isEmpty {
            for button in colorButtons {
                button.isEnabled = false
            }
            
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
            
            scores[currentPlayer] += 1
            
            updateScoresLabel()
            switchPlayers()
        }
    }
    @IBAction func actionButtonHandler(_ sender: UIButton) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize Colors", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        
        addNewColor()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { () -> Void in
            self.playSequence()
        })
    }
    
    func createNewGame(){
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        
        for button in colorButtons {
            button.alpha = 1.0
            button.isEnabled = false
        }
        
        currentPlayer = 0
        scores = [0,0]
        playerLabels[0].alpha = 1.0
        playerLabels[1].alpha = 0.5
        
        updateScoresLabel()
        
    }
    
    func updateScoresLabel(){
        for (index, label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }
    
    func switchPlayers() {
        playerLabels[currentPlayer].alpha = 0.50
        currentPlayer = currentPlayer == 0 ? 1 : 0
        playerLabels[currentPlayer].alpha = 1.0
        
    }
    
    func sortLabels() {
        colorButtons = colorButtons.sorted() {
            $0.tag < $1.tag
        }
        playerLabels = playerLabels.sorted() {
            $0.tag < $1.tag
        }
        scoreLabels = scoreLabels.sorted() {
            $0.tag < $1.tag
        }
    }
    
    func addNewColor() {
        colorSequence.append(Int(arc4random_uniform(UInt32(4))))
    }
    
    func playSequence() {
        if sequenceIndex < colorSequence.count {
            flash(button: colorButtons[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        } else {
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true
            actionButton.setTitle("Tap the circles", for: .normal)
            for button in colorButtons {
                button.isEnabled = true
            }
        }
    }
    
    func flash(button: CircularButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 0.5
            button.alpha = 1.0
        }, completion: { (bool) in
            self.playSequence()
            })
    }
    
    func endGame() {
        actionButton.setTitle(currentPlayer == 0 ? "Player 2 Wins!" : "Player 1 Wines!", for: .normal)
        gameEnded = true
    }
}

