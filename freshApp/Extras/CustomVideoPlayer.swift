//
//  CustomVideoPlayer.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/5/21.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    let controller = AVPlayerViewController()
    let url: URL
    let player1: AVPlayer
    
    init(url: URL) {
        self.url = url
        self.player1 = AVPlayer(url: url)
    }

  func makeUIViewController(context: Context) -> AVPlayerViewController {

    
    controller.player = player1
    return controller
  }
  
  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    
  }
}
