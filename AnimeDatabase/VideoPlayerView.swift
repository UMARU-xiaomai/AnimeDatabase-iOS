//
//  VideoPlayerView.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/29.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
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
