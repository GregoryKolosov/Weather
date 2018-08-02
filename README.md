# Weather
Weather App built with Swift.
![Gif](https://github.com/GregoryKolosov/Weather/blob/master/Design/WeatherGif.gif)
## Features
* Cute and Flat design.
* 3 day forecast.
* Search by city functional.
## API
[Dark Sky API](https://darksky.net/)
## Frameworks
* [Alamofire](https://cocoapods.org/pods/Alamofire)
* [SwiftyJSON](https://cocoapods.org/pods/SwiftyJSON)
* [GooglePlaces](https://developers.google.com/places/ios-sdk/autocomplete)
* [CoreLocation](https://developer.apple.com/documentation/corelocation)
## Contact me 
Facebook - https://www.facebook.com/gregory.kolosov
<br>
Telegram - https://t.me/KolosovGregory
<br>
Mail - <90kolosov@gmail.com>
## Icon
![Icon](https://github.com/GregoryKolosov/Weather/blob/master/Design/Icon.png)
## UI
![UI](https://github.com/GregoryKolosov/Weather/blob/master/Design/Weather%20Design.png)
## How to build
1. Clone the repository
```
$ git clone https://github.com/GregoryKolosov/Weather.git
```
2. Install pods
```
$ cd Weather
$ pod install
```
3. Open the workspace in Xcode.
```
$ open "Weather.xworkspace"
```
4. Sign up on <https://darksky.net/> and get your api key.
5. Add your api key in ViewController.swift
```swift
let darkSkyApi_KEY = "api key"
```
6. Compile and run the app in your simulator
