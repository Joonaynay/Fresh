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
        VStack {
            VideoPlayer(player: AVPlayer(url: url))
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}
