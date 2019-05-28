//
//  SongViewController.swift
//  DZ_iTunes
//
//  Created by user on 24/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import UIKit

class SongViewController: UIViewController {

    var url: URL!
    
    var playButtonPressed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        URLSession.shared.downloadTask(with: url) { (url, response, error) in
            
            let fileManager = FileManager.default
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            
            let documentsPathURL = URL(fileURLWithPath: documentsPath)
            
            var finalPath = documentsPathURL.appendingPathComponent("Preview")
            
           try? fileManager.createDirectory(at: finalPath, withIntermediateDirectories: true, attributes: nil)
            
            finalPath.appendPathComponent("qqq.m4a")
            
            do {
                try fileManager.copyItem(at: url!, to: finalPath)
            } catch {
                print(error.localizedDescription)
            }
            
            print()
        }.resume()
        
    }
    
    func animationButtonPressed(button: UIButton, completion:@escaping () -> ()) -> UIViewPropertyAnimator {
        let parameter = UICubicTimingParameters(animationCurve: .linear)
        let animator = UIViewPropertyAnimator(duration: 0.3, timingParameters: parameter)
        
        animator.addAnimations {
            button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            button.superview?.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        }
        
        animator.addCompletion { _ in
            completion()
        }
        
        return animator
    }
    
    @IBAction func actionBackwardButton(_ sender: UIButton) {
        
        let animator = animationButtonPressed(button: sender) {
            sender.transform = CGAffineTransform.identity
            sender.superview?.backgroundColor = .clear
        }
        animator.startAnimation()
    }
    
    @IBAction func actionForwardButton(_ sender: UIButton) {
        
        let animator = animationButtonPressed(button: sender) {
            sender.transform = CGAffineTransform.identity
            sender.superview?.backgroundColor = .clear
        }
        animator.startAnimation()
    }
    
    @IBAction func actionPlayButton(_ sender: UIButton) {
        
        let animator = animationButtonPressed(button: sender) {
            if self.playButtonPressed {
                sender.setImage(UIImage(named: "pause"), for: [])
            } else {
                sender.setImage(UIImage(named: "play"), for: [])
            }
            sender.transform = CGAffineTransform.identity
            sender.superview?.backgroundColor = .clear
            
            self.playButtonPressed.toggle()
        }
        
        animator.startAnimation()
    }


}

