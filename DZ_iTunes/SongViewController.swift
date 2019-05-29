//
//  SongViewController.swift
//  DZ_iTunes
//
//  Created by user on 24/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import UIKit
import AVFoundation

class SongViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    var song: Song!
    
    //var url: URL!
    
    var playButtonPressed = true

    var session: URLSession!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        session.downloadTask(with: song.previewUrl).resume()
        
        
//        URLSession.shared.downloadTask(with: url) { (url, response, error) in
//
//            let fileManager = FileManager.default
//
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//
//            let documentsPathURL = URL(fileURLWithPath: documentsPath)
//
//            var finalPath = documentsPathURL.appendingPathComponent("Preview")
//
//           try? fileManager.createDirectory(at: finalPath, withIntermediateDirectories: true, attributes: nil)
//
//            finalPath.appendPathComponent("qqq.m4a")
//
//            do {
//                try fileManager.copyItem(at: url!, to: finalPath)
//            } catch {
//                print(error.localizedDescription)
//            }
//
//            print()
//        }.resume()
        
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
        
        player!.currentTime -= 5
        
        let animator = animationButtonPressed(button: sender) {
            sender.transform = CGAffineTransform.identity
            sender.superview?.backgroundColor = .clear
        }
        animator.startAnimation()
    }
    
    @IBAction func actionForwardButton(_ sender: UIButton) {
        
        player!.currentTime += 5
        
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

extension SongViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo
        location: URL) {

        DispatchQueue.main.async {
            self.progressView.isHidden = true
        }
        
        let fileManager = FileManager.default
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        let documentsPathURL = URL(fileURLWithPath: documentsPath)
        
        var finalPath = documentsPathURL.appendingPathComponent("Preview")
        
        try? fileManager.createDirectory(at: finalPath, withIntermediateDirectories: true, attributes: nil)
        
        finalPath.appendPathComponent("\(self.song.artistName)-\(song.trackName).m4a")
        
        do {
            try fileManager.copyItem(at: location, to: finalPath)
        } catch {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.player = try? AVAudioPlayer(contentsOf: finalPath)
            self.player?.play()
        }
        
        print()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        //print("Progress: \(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))")
        
        DispatchQueue.main.async {
            self.progressView.setProgress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite), animated: true)
        }
    }

}

