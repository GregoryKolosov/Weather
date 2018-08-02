//
//  ViewController.swift
//  Weather
//
//  Created by Gregory Kolosov on 05/07/2018.
//  Copyright © 2018 Gregory Kolosov. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import GooglePlaces
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Global Variables
    // Location Manager implementation
    let locationManagerSetup = CLLocationManager()
    
    // Mutable String Init
    var myMutableString = NSMutableAttributedString()
    
    // Weather Model implementation
    let weatherModel = WeatherModel()
    let today = Today()
    let secondDay = SecondDay()
    let thirdDay = ThirdDay()
    let fourthDay = FourthDay()

    // Dark Sky Api information - https://api.darksky.net/forecast/[key]/[latitude],[longitude]
    let darkSkyApi_URL = "https://api.darksky.net/forecast/"
    let darkSkyApi_KEY = "e81179a049096be184ac32d8cd1353c2"
    
    // Google Places service variables
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let GMSAutoComplete = GMSAutocompleteViewController()

    // MARK: - Outlets & Buttons
    @IBOutlet weak var mainIcon: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    
    @IBOutlet weak var secondDayNameLabel: UILabel!
    @IBOutlet weak var secondDayTemperatureLabel: UILabel!
    
    @IBOutlet weak var thirdDayNameLabel: UILabel!
    @IBOutlet weak var thirdDayTemperatureLabel: UILabel!
    
    @IBOutlet weak var fourthDayNameLabel: UILabel!
    @IBOutlet weak var fourthDayTemperatureLabel: UILabel!
    
    // Views
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var forecastView: UIView!
    
    // MARK: - Load View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ui setup while loading in process
        cleanUI()
        
        // Set colour of Status bar
        // defined in Project like light
        
        // Location Manager Setup
        locationManagerSetup.delegate = self
        locationManagerSetup.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManagerSetup.requestWhenInUseAuthorization()
        locationManagerSetup.startUpdatingLocation()
        
        // Google places setup
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Google places search bar UI setup
        let subView = UIView(frame: CGRect(x: 0, y: 40.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.tintColor = UIColor.white
        searchController?.searchBar.barTintColor = UIColor.white
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    // MARK: - Location Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManagerSetup.stopUpdatingLocation()
            locationManagerSetup.delegate = nil
            print("longtitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            getWeatherData(latitude: latitude, longitude: longitude)
        }
    }

    // Location manager error!
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.currentSummaryLabel.text = "Can't determine your location!"
    }
    
    // MARK: - Weather Data from Dark Sky
    // Alamofire getWeatherData metod:
    func getWeatherData(latitude: String, longitude: String) {
        
        let url = darkSkyApi_URL + darkSkyApi_KEY + "/\(latitude),\(longitude)"
        print(url)
        Alamofire.request(url).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                self.currentSummaryLabel.text = "Problem with internet connection!"
                print("Error! \(response.result.error!)")
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        // Current Weather
        weatherModel.timezone = json["timezone"].stringValue
        today.time = convertUnixTimeToString(time: json["currently"]["time"].doubleValue)
        today.summary = json["currently"]["summary"].stringValue
        let fahrengeitToday = json["currently"]["temperature"].doubleValue
        today.temperature = Int((fahrengeitToday - 32) * 5 / 9)
        today.feelsLike = json["currently"]["apparentTemperature"].intValue
        today.icon = json["currently"]["icon"].stringValue
        
        print(today.icon)
        
        
        
        // Second Day Weateher
        secondDay.time = convertUnixTimeToString(time: json["daily"]["data"][1]["time"].doubleValue)
        secondDay.summary = json["daily"]["data"][1]["summary"].stringValue
        let fahrengeitSecond = json["daily"]["data"][1]["apparentTemperatureHigh"].doubleValue
        secondDay.apparentTemperatureHigh = Int((fahrengeitSecond - 32) * 5 / 9)
        secondDay.icon = json["daily"]["data"][1]["icon"].stringValue
        
        // Third Day Weather
        thirdDay.time = convertUnixTimeToString(time: json["daily"]["data"][2]["time"].doubleValue)
        thirdDay.summary = json["daily"]["data"][2]["summary"].stringValue
        let fahrengeitThird = json["daily"]["data"][2]["apparentTemperatureHigh"].doubleValue
        thirdDay.apparentTemperatureHigh = Int((fahrengeitThird - 32) * 5 / 9)
        thirdDay.icon = json["daily"]["data"][2]["icon"].stringValue
        
        // Fourth Day Weather
        fourthDay.time = convertUnixTimeToString(time: json["daily"]["data"][3]["time"].doubleValue)
        fourthDay.summary = json["daily"]["data"][3]["summary"].stringValue
        let fahrengeitFourth = json["daily"]["data"][3]["apparentTemperatureHigh"].doubleValue
        fourthDay.apparentTemperatureHigh = Int((fahrengeitFourth - 32) * 5 / 9)
        fourthDay.icon = json["daily"]["data"][3]["icon"].stringValue
        
        // Update UI interface
        updateUI()
    }
    
    // MARK: - UI
    // Update UI
    func updateUI() {
        mainIcon.isHidden = false
        mainIcon.image = UIImage(named: today.icon)
        
        currentTemperatureLabel.text = "\(today.temperature)°"
        currentTemperatureLabel.sizeToFit()
        currentSummaryLabel.text = "It's \(today.summary) outside."
        currentSummaryLabel.sizeToFit()
        
        secondDayNameLabel.text = "\(secondDay.time)"
        secondDayTemperatureLabel.text = "\(secondDay.apparentTemperatureHigh)°"
        
        thirdDayNameLabel.text = "\(thirdDay.time)"
        thirdDayTemperatureLabel.text = "\(thirdDay.apparentTemperatureHigh)°"
        
        fourthDayNameLabel.text = "\(fourthDay.time)"
        fourthDayTemperatureLabel.text = "\(fourthDay.apparentTemperatureHigh)°"
        
        searchController?.searchBar.placeholder = "\(weatherModel.timezone)"
        
        // Background Colour Set
        switch today.icon {
        case "wind" :
            view.backgroundColor = UIColor(hexString: "#94AFF9")
        case "snow" :
            view.backgroundColor = UIColor(hexString: "#2B75DC")
        case "sleet" :
            view.backgroundColor = UIColor(hexString: "#50B9EB")
        case "rain" :
            view.backgroundColor = UIColor(hexString: "#49577F")
        case "partly-cloudy-night" :
            view.backgroundColor = UIColor(hexString: "#262632")
        case "partly-cloudy-day" :
            view.backgroundColor = UIColor(hexString: "F2B1C6")
        case "fog" :
            view.backgroundColor = UIColor(hexString: "#A5BDC5")
        case "cloudy" :
            view.backgroundColor = UIColor(hexString: "#57BBBA")
        case "clear-night" :
            view.backgroundColor = UIColor(hexString: "#26263B")
        case "clear-day" :
            view.backgroundColor = UIColor(hexString: "#E44A5D")
    
        default:
            view.backgroundColor = UIColor(hexString: "F2B1C6")
        }
    }

    // Clean UI for start
    func cleanUI() {
        view.backgroundColor = UIColor.darkGray
        currentSummaryLabel.text = "Loading..."
        currentTemperatureLabel.text = "--°"
        secondDayNameLabel.text = ""
        secondDayTemperatureLabel.text = "--°"
        thirdDayNameLabel.text = ""
        thirdDayTemperatureLabel.text = "--°"
        fourthDayNameLabel.text = ""
        fourthDayTemperatureLabel.text = "--°"
    }
    
    // MARK: - Support functions
    // Convert unix time to string date
    func convertUnixTimeToString(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: weatherModel.timezone)
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EE"
        
        // yyyy-MM-dd HH:mm
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    // Set background Image function
    func assignBackground() {
        let background = UIImage(named: "Background.png")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
} // E N D

// MARK: - Extensions
// Google Places extension
extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        // Get Weather Data with google places params
        getWeatherData(latitude: String(place.coordinate.latitude), longitude: String(place.coordinate.longitude))
      
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
} // Extensions E N D


