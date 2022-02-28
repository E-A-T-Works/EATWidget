//
//  LoopingPlayer.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/15/22.
//
//  References:
//      https://schwiftyui.com/swiftui/playing-videos-on-a-loop-in-swiftui/
//

import SwiftUI
import AVFoundation

struct LoopingPlayer: UIViewRepresentable {
    
    let animationUrl: URL
    
    init(animationUrl: URL) {
        self.animationUrl = animationUrl
        
        setAudioToAmbient()
    }
    
    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(animationUrl: animationUrl, frame: .zero)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing here
    }
    
    private func setAudioToAmbient() {
        // ref: https://stackoverflow.com/questions/31671029/prevent-avplayer-from-canceling-background-audio
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch {
            print("⚠️ \(error)")
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("⚠️ \(error)")
        }
    }
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    init(animationUrl: URL, frame: CGRect) {
        super.init(frame: frame)
        
        // Load Video
        let fileUrl = animationUrl
        let playerItem = AVPlayerItem(url: fileUrl)
        
        // Setup Player
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        
        // Loop
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        // Play
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    
    init(animationUrl: URL, frame: CGRect) {
        super.init(frame: frame)
            
        // Load Video
        let fileUrl = animationUrl
        let playerItem = AVPlayerItem(url: fileUrl)
        
        // Setup Player
        let player = AVPlayer(playerItem: playerItem)

        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        // Loop
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(rewindVideo(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        // Play
        player.play()
    }
    
    @objc
    func rewindVideo(notification: Notification) {
        playerLayer.player?.seek(to: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct LoopingPlayer_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoopingPlayer(
                animationUrl: URL(string: "https://res.cloudinary.com/nifty-gateway/video/upload/v1613068880/A/SuperPlastic/Kranky_Metal_As_Fuck_Black_Edition_Superplastic_X_SketOne_wyhzcf_hivljh.mp4")!
            )
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
