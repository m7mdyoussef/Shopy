////
////  ICanPlaySound.swift
////  Shopy
////
////  Created by Amin on 15/06/2021.
////  Copyright © 2021 mohamed youssef. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//
//protocol ICanPlaySound {
//    var player : AVAudioPlayer?{get set}
//    func playSound(name:String,ext:String)
//}
//
//extension ICanPlaySound{
//    
////    var player:AVAudioPlayer = nil
////    var player = nil
//    
//    mutating func playSound(name:String,ext:String = "mp3")  {
//        guard let path = Bundle.main.path(forResource: name, ofType: ext) else {return}
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//        } catch(let err) {
//            print("could load \(err)")
//        }
//
//    }
//}
////