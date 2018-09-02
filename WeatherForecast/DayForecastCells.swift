//
//  DayForecastCells.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 22/05/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import UIKit

class SmallWeatherCell: UICollectionViewCell {
    let timeLabel: UILabel = UILabel()
    let weatherIconImageView: UIImageView = UIImageView()
    let tempLabel: UILabel = UILabel()
    let windDirectionIndicator: WindDirectionIndicator = WindDirectionIndicator()
    let windSpeedLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        timeLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        windSpeedLabel.textAlignment = .center
        
        windDirectionIndicator.backgroundColor = UIColor.clear
        windSpeedLabel.textColor = UIColor.black
        tempLabel.textColor = UIColor.white
        timeLabel.textColor = UIColor.white
        
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        contentView.addAutoconstrainedSubviews(timeLabel, weatherIconImageView, tempLabel, windDirectionIndicator, windSpeedLabel)
        
        timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        NSLayoutConstraint(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 0.25, constant: 0).isActive = true
        
        weatherIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherIconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true
        NSLayoutConstraint(item: weatherIconImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 0.75, constant: 0).isActive = true
        
        tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        NSLayoutConstraint(item: tempLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.25, constant: 0).isActive = true
        
        windDirectionIndicator.heightAnchor.constraint(equalTo: windDirectionIndicator.widthAnchor).isActive = true
        windDirectionIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        windDirectionIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        NSLayoutConstraint(item: windDirectionIndicator, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.65, constant: 0).isActive = true
        
        windSpeedLabel.centerXAnchor.constraint(equalTo: windDirectionIndicator.centerXAnchor).isActive = true
        windSpeedLabel.centerYAnchor.constraint(equalTo: windDirectionIndicator.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BigWeatherCell: UICollectionViewCell {
    let maxTempLabel: UILabel = UILabel()
    let minTempLabel: UILabel = UILabel()
    let weatherIconImageView: UIImageView = UIImageView()
    let weatherStatusLabel: UILabel = UILabel()
    let windDirectionIndicator: WindDirectionIndicator = WindDirectionIndicator()
    let windSpeedLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        maxTempLabel.font = UIFont.init(name: "Helvetica Neue", size: 90.0)
        minTempLabel.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 75.0)
        weatherStatusLabel.font = UIFont.init(name: "Helvetica Neue", size: 37.0)
        
        windDirectionIndicator.backgroundColor = UIColor.clear
        windSpeedLabel.textColor = UIColor.black
        minTempLabel.textColor = UIColor.white
        maxTempLabel.textColor = UIColor.white
        weatherStatusLabel.textColor = UIColor.white
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.addAutoconstrainedSubviews(maxTempLabel, minTempLabel, weatherIconImageView, weatherStatusLabel, windDirectionIndicator, windSpeedLabel)
        
        maxTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        maxTempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        minTempLabel.trailingAnchor.constraint(equalTo: maxTempLabel.trailingAnchor).isActive = true
        minTempLabel.topAnchor.constraint(equalTo: maxTempLabel.bottomAnchor, constant: -10).isActive = true
        
        weatherIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50).isActive = true
        weatherIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        weatherIconImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true // should be proportional?
        weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true
        
        weatherStatusLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor).isActive = true
        weatherStatusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        windDirectionIndicator.topAnchor.constraint(equalTo: minTempLabel.bottomAnchor, constant: 5).isActive = true
        windDirectionIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        windDirectionIndicator.widthAnchor.constraint(equalToConstant: 70).isActive = true
        windDirectionIndicator.heightAnchor.constraint(equalTo: windDirectionIndicator.widthAnchor).isActive = true
        
        windSpeedLabel.centerXAnchor.constraint(equalTo: windDirectionIndicator.centerXAnchor).isActive = true
        windSpeedLabel.centerYAnchor.constraint(equalTo: windDirectionIndicator.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

