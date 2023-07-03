import UIKit

extension ViewController: WeatherDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // UI Obejct Update
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.cityNameLabel.text = weather.cityName
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.weatherImage.tintColor = .white
        }
        return
    }
    
    func didFailWithError(error: Error) {
        fatalError("Not get Data")
    }
}
