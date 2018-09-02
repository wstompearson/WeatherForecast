//
//  WeatherError.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 26/05/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import Foundation

struct WeatherError {
    enum ErrorType {
        case dataRequestFailure
        case invalidSearch
        case decoderFailure
        case other
    }
    
    let error: ErrorType
    let messgae: String
}
