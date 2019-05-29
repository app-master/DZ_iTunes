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
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var session: URLSession!
    var player: AVAudioPlayer?
    var song: Song!
    var playButtonPressed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let finalPath = URL.songPathURL(with: self.song.artistName, trackName: song.trackName)
        
        if FileManager.default.fileExists(atPath: finalPath.path) {
            setupAudioPlayer(contentsOf: finalPath)
            actionButtonsIsEnabled(true)
        } else {
            progressView.isHidden = false
            session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            
            session.downloadTask(with: song.previewUrl).resume()
        }
    }
    
    func setupAudioPlayer(contentsOf url: URL) {
        self.player = try? AVAudioPlayer(contentsOf: url)
        self.player?.delegate = self
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
    
    func actionButtonsIsEnabled(_ isEnabled: Bool) {
        backwardButton.isEnabled = isEnabled
        playButton.isEnabled = isEnabled
        forwardButton.isEnabled = isEnabled
    }
    
    func animationForPlayButton(_ sender: UIButton, completion: @escaping () -> Void) {
        let animator = animationButtonPressed(button: sender) {
            if self.playButtonPressed {
                sender.setImage(UIImage(named: "pause"), for: [])
            } else {
                sender.setImage(UIImage(named: "play"), for: [])
            }
            sender.transform = CGAffineTransform.identity
            sender.superview?.backgroundColor = .clear
            
            completion()
        }
        animator.startAnimation()
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
        
        if self.playButtonPressed {
            player?.play()
        } else {
            player?.pause()
        }
        animationForPlayButton(sender) {
            self.playButtonPressed.toggle()
        }
    }
}

extension SongViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo
        location: URL) {

//        DispatchQueue.main.async {
//            self.progressView.isHidden = true
//        }
        
//        let fileManager = FileManager.default
//        
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//        
//        let documentsPathURL = URL(fileURLWithPath: documentsPath)
//        
//        var finalPath = documentsPathURL.appendingPathComponent("Preview")
//        
//        try? fileManager.createDirectory(at: finalPath, withIntermediateDirectories: true, attributes: nil)
//        
//        finalPath.appendPathComponent("\(self.song.artistName)-\(song.trackName).m4a")
        
        let path = URL.songPathURL(with: self.song.artistName, trackName: song.trackName)
        
        do {
            try FileManager.default.copyItem(at: location, to: path)
            setupAudioPlayer(contentsOf: path)
        } catch {
            print(error.localizedDescription)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        DispatchQueue.main.async {
            self.progressView.setProgress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite), animated: true)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        DispatchQueue.main.async {
            self.progressView.isHidden = true
        }
        
        if let error = error {
            self.showAlertWithMessage(error.localizedDescription)
            return
        }
        
        DispatchQueue.main.async {
            self.actionButtonsIsEnabled(true)
        }
    }

}

extension SongViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        animationForPlayButton(playButton) {
            self.playButtonPressed.toggle()
        }
    }
}

