//
//  ViewController.swift
//  Weather_Application
//
//  Created by Manikandan Annadurai on 22/09/23.
//

import UIKit
import Alamofire
import SwiftyJSON



class WeatherViewController: UIViewController, ChangeCityDelegate {
    
    
    //API Caller
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=8b1213296544cdf197a315605911d5b7"
 
    let weatherDataModel = WeatherDataModel()
   
    
    @IBOutlet weak var WeatherView: UIView!
    @IBOutlet weak var ViewImage: UIImageView!
    @IBOutlet weak var Citylabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var ClimateLabel: UILabel!
    @IBOutlet weak var iconName: UILabel!
    @IBOutlet weak var weatherimage: UIImageView!
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var WeatherDetails: UILabel!
    @IBOutlet weak var Realfeel: UILabel!
    @IBOutlet weak var feelslike: UILabel!
    @IBOutlet weak var Humidity: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var Windspeed: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var Pressure: UILabel!
    @IBOutlet weak var PressureLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       userEnteredANewCityName(city: "Trichy")
        Display()
    
    }
    
    
    func Display()
    {
        WeatherDetails.label()
        Realfeel.label()
        feelslike.label()
        Humidity.label()
        humidityLabel.label()
        Windspeed.label()
        windspeedLabel.label()
        Pressure.label()
        PressureLabel.label()
        WeatherView.View()
        ViewImage.imageView()
        NextButton.ButtonDisplay()
        Citylabel.label()
        tempLabel.label()
        iconName.label()
        ClimateLabel.label()
        weatherimage.imageView()
        
        
    }
    
    // Networking for WeatherMoniter
    
    func getWeatherData(url: String){
        
        
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON from server response: \(json)")
                self.updateWeatherData(json: json)
                
                
                
                break
            case .failure(let error):
                print("Connection Issues")
                print(error)
                self.Citylabel.text = "Check Internet"
            }
        }
        
    }
    
    
   //JSON Parsing
    
    func updateWeatherData(json: JSON){
        
        if let weatherCondition = json["weather"][0]["id"].int {
            weatherDataModel.temperature = json["main"]["temp"].int
            weatherDataModel.city = json["name"].string
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherCondition)
            weatherDataModel.weatherDescription = json["weather"][0]["description"].string
            weatherDataModel.weatherName = json["weather"][0]["main"].string
            weatherDataModel.Feelslike = json["main"]["feels_like"].int
            weatherDataModel.Humdiity = json["main"]["humidity"].int
            weatherDataModel.WindSpeed = json["wind"]["speed"].double
            weatherDataModel.Pressure = json["main"]["pressure"].int
            weatherDataModel.messageError = json["message"].string
            
            updateUIWithWeatherData()
        }
        else {
            weatherDataModel.messageError = json["message"].string
            Citylabel.text = weatherDataModel.messageError?.uppercased()
            print(json)
            if Citylabel.text == "CITY NOT FOUND" {
                
                let alert = UIAlertController(title: "WRONG CITY NAME", message: "Correct a name of the city", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.performSegue(withIdentifier: "changeCityName", sender: self)
                })
                
                present(alert, animated: true, completion: nil)
                
                
                
            }
            
        }
    }
    
    
    
    // UI Updates
    
    func updateUIWithWeatherData(){
        
        
        
        Citylabel.text = weatherDataModel.city?.uppercased()
        iconName.text = weatherDataModel.weatherDescription?.uppercased()
        ClimateLabel.text = weatherDataModel.weatherName?.uppercased()
        weatherimage.image = UIImage(named: weatherDataModel.weatherIconName!)
        tempLabel.text = "\(weatherDataModel.temperature!)°"
        feelslike.text = "\(weatherDataModel.Feelslike!)°"
        humidityLabel.text = "\(weatherDataModel.Humdiity!)%"
        windspeedLabel.text = "\(weatherDataModel.WindSpeed!)km/h"
        PressureLabel.text = "\(weatherDataModel.Pressure!)mbar"
        
        
        
    }
    
    
    
    @IBAction func tempconverter(_ sender: Any) {
        
        switch SegmentedControl.selectedSegmentIndex
        {
        case 0:
            tempLabel.text = "\(weatherDataModel.temperature!)°"
            feelslike.text = "\(weatherDataModel.Feelslike!)°"
        case 1:
            tempLabel.text = "\(weatherDataModel.temperature! * 9 / 5 + 32)°"
            feelslike.text = "\(weatherDataModel.Feelslike! * 9 / 5 + 32)°"
        default:
            break
        }
        
        
    }
    
    
    // Change City Delegate methods
    func userEnteredANewCityName(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        getWeatherData(url: urlString)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! CityNameViewController
            destinationVC.delegate = self
        }
    }
    
    
}


