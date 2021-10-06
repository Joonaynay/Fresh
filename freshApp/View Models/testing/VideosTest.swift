//
//  VideosTest.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import Foundation
import AVKit

class VideosTest: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "train", ofType: "m4v")!))
        
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true)
    }
    
}
