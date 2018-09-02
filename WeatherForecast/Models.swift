//
//  Models.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 26/04/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [WeatherItem]
    let city: City
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
}

struct Coord: Decodable {
    let lat, lon: Double
}

struct WeatherItem: Decodable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let sys: Sys
    let dt_txt: String
}

struct Main: Decodable {
    let temp, temp_min, temp_max, pressure, sea_level, grnd_level, temp_kf: Double
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
    let description, icon: String
    let main: WeatherType
    
    enum WeatherType: String, Decodable {
        case Clouds, Rain, Clear, Thunderstorm, Drizzle, Snow, Atmosphere
    }
}

struct Clouds: Decodable {
    let all: Int
}

struct Wind: Decodable {
    let speed, deg: Double
}

struct Sys: Decodable {
    let pod: String
}

protocol WeatherDisplayable {
    var maxTemp: Double { get }
    var minTemp: Double { get }
    var windDirection: Double { get }
    var windSpeed: Double { get }
    var weatherIcon: Weather.WeatherType { get }
    var weatherDescription: String { get }
    var dateDescription: String { get }
    var day: String { get }
}

extension WeatherDisplayable {
    var averageTemp: Double {
        return (maxTemp + minTemp) / 2
    }
}

extension WeatherItem: WeatherDisplayable {
    var maxTemp: Double { return main.temp_max }
    var minTemp: Double { return main.temp_min }
    var windDirection: Double { return wind.deg }
    var windSpeed: Double { return wind.speed }
    var weatherIcon: Weather.WeatherType { return weather[0].main }
    //could possibly fail here... unknown enum?
    var weatherDescription: String { return weather[0].description }
    var dateDescription: String { return getNiceDateString(fromTimeInterval: dt) }
    var day: String { return getDay(fromTimeInterval: dt)}
    
    private func getNiceDateString(fromTimeInterval interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: date) + " " + timeFormatter.string(from: date)
    }
    
    private func getDay(fromTimeInterval interval: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        return formatter.string(from: date)
    }
}

extension Array: WeatherDisplayable where Element: WeatherDisplayable {
    var maxTemp: Double {
        return self.map{$0.maxTemp}.max()!
    }
    
    var minTemp: Double {
        return self.map{$0.minTemp}.min()!
    }
    
    var windDirection: Double {
        return self.map{$0.windDirection}.average
    }
    
    var windSpeed: Double {
        return self.map{$0.windSpeed}.average
    }
    
    var weatherIcon: Weather.WeatherType {
        return self.map{$0.weatherIcon}.mostOccuring!
    }
    
    var weatherDescription: String {
        switch weatherIcon {
        case .Clouds:
            return self.map{$0.weatherDescription}.filter{$0.contains("cloud")}.mostOccuring ?? "Error"
        case .Rain:
            return self.map{$0.weatherDescription}.filter{$0.contains("rain")}.mostOccuring ?? "Error"
        case .Clear:
            return self.map{$0.weatherDescription}.filter{$0.contains("clear")}.mostOccuring ?? "Error"
        default:
            return self.map{$0.weatherDescription}.mostOccuring!
        }
    }
    
    var dateDescription: String {
        return day
    }
    
    var day: String {
        return self.count > 0 ? self[0].day : "error"
    }
}
