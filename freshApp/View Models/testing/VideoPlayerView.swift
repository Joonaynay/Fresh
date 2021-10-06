//
//  VideoPlayer.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/5/21.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!
    
    var body: some View {
//        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "train", ofType: "m4v")!))
//        let vc = AVPlayerViewController()
//        vc.player = player
//        present(vc, animated: true)
        
        VStack {

        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}
