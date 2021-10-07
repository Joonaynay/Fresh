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
    @Binding var player: AVPlayer?

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    controller.player = player
    return controller
  }
  
  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    
  }
}
