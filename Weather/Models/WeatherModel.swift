//
//  WeatherModel.swift
//  Weather
//
//  Created by Gregory Kolosov on 05/07/2018.
//  Copyright © 2018 Gregory Kolosov. All rights reserved.
//

import Foundation

class WeatherModel {
 
    var temperature: Int = 0
    var feelsLike: Int = 0
    var summary: String = ""
    var icon: String = ""
    var time: String = ""
    var timezone: String = ""
    
}

class Today: WeatherModel {
    
}

class SecondDay: WeatherModel {
    var apparentTemperatureHigh: Int = 0
}

class ThirdDay: WeatherModel {
    var apparentTemperatureHigh: Int = 0
}

class FourthDay: WeatherModel {
    var apparentTemperatureHigh: Int = 0
}
