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
        if let error = error as? URLError {
            self.makeAlertMessage(title: "요청 에러: \(String(error.code.rawValue))")
        } else {
            self.makeAlertMessage(title: "어플리케이션 오류가 발생했습니다.")
        }
    }
    
    func makeAlertMessage(title: String){
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}
