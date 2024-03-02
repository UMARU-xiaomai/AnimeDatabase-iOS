//
//  VideoPlayerView.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/29.
//

import AVFoundation
import AVKit
import SwiftUI

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        // 设置音频会话类别为.playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("设置音频会话属性失败：\(error.localizedDescription)")
        }
        
        // 创建AVPlayer和AVPlayerViewController
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.modalPresentationStyle = .fullScreen
        
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No update needed
    }
}
