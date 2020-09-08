//
//  ViewController.swift
//  test
//
//  Created by Work on 2020/6/20.
//  Copyright © 2020 yanzhen. All rights reserved.
//

import UIKit
import MSBPlayer

private let video = "http://s2.meixiu.mobi/courseware/test/texiao/ES2U102KABWL/errors/2.mp4"




class ViewController: UIViewController {

    private var index = 1
    let context  = CIContext(options: nil)
    @IBOutlet private weak var smallPlayer: UIImageView!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var timeLabel: UILabel!
    private var player: MSBAIPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playVideo()
    }
    
    
    
    @IBAction private func seekTo(_ sender: UISlider) {
        player?.seek(toTime: TimeInterval(slider.value))
    }
    

    @IBAction private func pausePlay(_ sender: UIButton) {
        if sender.isSelected {
            player?.resume()
        } else {
            player?.pause()
        }
        sender.isSelected.toggle()
    }
    
}

private extension ViewController {
    func playVideo() {
        let path = Bundle.main.path(forResource: "1", ofType: "mp4")
        
        let url = URL(fileURLWithPath: path!)
//        let url = URL(string: "http://39.107.116.40/res/tpl/default/file/guoke.mp4")
            //URL(string: "https://xiaoxiong-private.oss-cn-hangzhou.aliyuncs.com/courseware/product/temp/0ac7c090c4d611ea8ad70b2b8db29493.mp4")
        
        
//        player = MSBAIApplePlayer(url: url)
//        player = MSBAIPlayer(url: url)
        player = MSBAIPlayer(url: url, mode: .toolBoxSync)
        player?.videoGravity = .resizeAspect
        player?.attach(to: view)
    
        
        player?.playerStatus = { [weak self] (status, error) in
            print("status:", status.rawValue, error)
            if status == .readyToPlay {
                self?.player?.play()
            }
        }
        
        player?.playbackStatus = { [weak self] (status) in
            guard let self = self else {
                return
            }
            print(status.rawValue, "end")
            if status == .ended {
//                self.player?.stop()
//                self.player = nil
//                self.index += 1
//                if self.index < 12 {
//                    self.playVideo()
//                }
            }
        }
                
        player?.playbackTime = { [weak self] (time, duration) in
            self?.slider.maximumValue = Float(duration)
            self?.slider.value = Float(time)
            self?.timeLabel.text = String(format: "%.f/%.f", time, duration)
        }
        
        player?.audioDataBlock = { (sampleRate, channels, data, size) in
            print(1234, sampleRate, channels, data, size);
        }
        
        player?.videoDataBlock = { [weak self] (buffer) in
            self?.displayVideo(buffer)
        }
        
        player?.loadedTime = { (time, duration) in
//            print("load:", time, duration)
        }
    }
}


private extension ViewController {
    func displayVideo(_ pixelBuffer: CVPixelBuffer?) {
        guard let pixelBuffer = pixelBuffer else { return }
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        guard let videoImageRef = context.createCGImage(ciImage, from: .init(x: 0, y: 0, width: width, height: height)) else {
            return
        }
        let image = UIImage(cgImage: videoImageRef)
        DispatchQueue.main.async {
            self.smallPlayer.image = image
        }
    }
}
