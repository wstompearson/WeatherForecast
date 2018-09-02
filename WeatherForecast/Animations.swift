//
//  Animations.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 22/05/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import Foundation

//    private func rotateView(_ view: UIView, toAngle angle: CGFloat) {
//        UIView.animate(withDuration: 0.5) {
//            view.transform = CGAffineTransform(rotationAngle: angle)
//        }
//    }
//
//    var rotation: UIViewPropertyAnimator?
//    var fluxuation: UIViewPropertyAnimator?
//
//    private func rotateView(targetView: UIView, duration: Double = 1.0) {
//        UIView.animate(withDuration: duration, delay: 0.0, options: [ .repeat], animations: {
//            targetView.transform = targetView.transform.rotated(by: CGFloat.pi)
//        })
//    }
//
//    private func fluxuateSizeOfView(targetView: UIView, duration: Double, scale: CGFloat) {
//        UIView.animate(withDuration: duration, delay: 0.0, options: [.autoreverse, .repeat], animations: {
//            targetView.transform = targetView.transform.scaledBy(x: scale, y: scale)
//        }, completion: { _ in
//            targetView.transform = targetView.transform.scaledBy(x: 1/scale, y: 1/scale)
//        })
//    }
//
//    private func translateViewHorzontally(targetView: UIView, duration: Double, initialDirection: String) {
//        let distance: CGFloat = 15
//        UIView.animate(withDuration: duration, delay: 0.0, options: [.autoreverse, .repeat], animations: {
//            if initialDirection == "right" {
//                targetView.frame.origin.x += distance
//            } else {
//                targetView.frame.origin.x -= distance
//            }
//        }, completion: { _ in
//            if initialDirection == "right" {
//                targetView.frame.origin.x -= distance
//            } else {
//                targetView.frame.origin.x += distance
//            }
//        })
//    }
