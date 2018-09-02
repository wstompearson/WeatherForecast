//
//  WeatherDataSource.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 28/04/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

typealias DayOfWeather = [WeatherItem]

protocol WeatherDataSource {
    var daysOfWeather: [DayOfWeather] { get }
    var currentWeather: WeatherItem? { get }
    var city: City { get }
}
