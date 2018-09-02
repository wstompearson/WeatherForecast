//
//  AssetFactory.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 26/05/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import UIKit

struct AssetFactory {
    static func getImage(forWeatherType type: Weather.WeatherType?) -> UIImage? {
        guard let type = type else { return nil }
        let assetName: String
        switch type {
        case .Clear:
            assetName = "sun"
        case .Rain:
            assetName = "rainyCloud"
        case .Clouds:
            assetName = "cloud"
        default:
            return nil
        }
        return UIImage(named: assetName)
    }
    
    static func getBackgroundImage(forWeatherType type: Weather.WeatherType?) -> UIImage? {
        guard let type = type else { return nil }
        let assetName: String
        switch type {
        case .Clear:
            assetName =  "BlueSkyWithClouds"
        case .Rain:
            assetName = "RainySky"
        case .Clouds:
            assetName = "GreySky"
        default:
            return nil
        }
        return UIImage(named: assetName)
    }
}
