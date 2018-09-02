//
//  DataSource.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 26/04/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import Foundation

class URLWeatherDataFetcher {
    static func makeURLRequestForData(locationQuery: String, errorHandler: @escaping (WeatherError)->(), dataAvailable: @escaping (URLWeatherDataSource)->()) {
        guard let locationQueryEncoded = locationQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?\(locationQueryEncoded)&appid=cf6e89c04bfb39ec2805d49da14d073c&units=metric")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                errorHandler(WeatherError(error: .dataRequestFailure, messgae: "Couldn't get Data"))
                return
            }
            
            do {
                let dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                if let myDictionary = dictonary {
                    if myDictionary["cod"] != nil, let errorMessage = myDictionary["message"] as? String {
                        errorHandler(WeatherError(error: .decoderFailure, messgae: errorMessage))
                        return
                    }
                }
            } catch let error {
                errorHandler(WeatherError(error: .other, messgae: error.localizedDescription))
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let dataSource = URLWeatherDataSource(response: weatherResponse)
                dataAvailable(dataSource)
                DispatchQueue.main.async {
                    UserDefaults.standard.set(locationQueryEncoded, forKey: "previousQuery")
                }
            } catch let error {
                errorHandler(WeatherError(error: .other, messgae: error.localizedDescription))
            }
        }
        task.resume()
    }
}

class URLWeatherDataSource: WeatherDataSource {
    var currentWeather: WeatherItem? {
        guard daysOfWeather.count > 0, daysOfWeather[0].count > 0 else {
            return nil
        }
        return daysOfWeather[0][0]
    }
    
    var daysOfWeather: [DayOfWeather] = []
    
    let city: City
    
    fileprivate init(response: WeatherResponse) {
        city = response.city
        
        let weatherItems = response.list
        var daysOfWeather: [DayOfWeather] = [[]]
        var counter: Int = 0
        var lastDay: String = getDayFromTimeStamp(timestamp: weatherItems.first!.dt_txt)
        
        for weatherItem in weatherItems {
            let day = getDayFromTimeStamp(timestamp: weatherItem.dt_txt)
            if day != lastDay {
                counter += 1
                lastDay = day
                daysOfWeather.append([])
            }
            daysOfWeather[counter].append(weatherItem)
        }
        self.daysOfWeather = daysOfWeather
    }
    
    private func getDayFromTimeStamp(timestamp: String) -> String {
        let comps = timestamp.components(separatedBy: "-")
        guard comps.count == 3 else { return "" }
        let day = comps[2]
        return String(day[day.index(after: day.startIndex) ..< day.index(day.startIndex, offsetBy: 2)])
    }
    
    convenience init() {
        self.init(response: WeatherResponse(cod: "", message: 0.0, cnt: 0, list: [], city: City(id: 0, name: "", coord: Coord(lat: 0.0, lon: 0.0), country: "", population: 0)))
    }
}
