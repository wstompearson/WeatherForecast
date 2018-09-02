//
//  Extensions.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 28/04/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func scrollToStart() {
        self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
    }
}

extension Double {
    var integerDescription: String {
        return Int(self.rounded()).description
    }
    
    var temperatureDescription: String {
        return integerDescription + "°"
    }
}

extension Array where Element == Double {
    var average: Double {
        return self.reduce(0, +) / Double(self.count)
    }
}

extension Array where Element: Hashable {
    var mostOccuring: Element? {
        guard self.count > 0 else { return nil }
        var hitCounter: [Element: Int] = [:]
        for item in self {
            if hitCounter[item] == nil {
                hitCounter[item] = 1
            } else {
                hitCounter[item]! += 1
            }
        }
        if let max = hitCounter.map({$0.value}).max() {
            return hitCounter.first(where: {$0.value == max})?.key
        }
        return nil
    }
}

extension Array where Element == WeatherItem {
    var maxTemp: Double {
        return self.map{$0.main.temp_max}.max() ?? 0.0
    }
    
    var minTemp: Double {
        return self.map{$0.main.temp_min}.min() ?? 0.0
    }
}

extension String {
    var titleCased: String {
        var result: [String] = []
        for word in self.components(separatedBy: .whitespaces) {
            let titleCasedWord = String(word[word.startIndex]).uppercased() + String(word[index(word.startIndex, offsetBy: 1)...])
            result.append(titleCasedWord)
        }
        return result.joined(separator: " ")
    }
}

extension UIView {
    func addAutoconstrainedSubviews(_ subviews: UIView ...) {
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }
}
