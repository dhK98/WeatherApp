import Foundation
// fetching weather from lat & lon
// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
// fetching weather from cityName
// https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}

protocol WeatherDelegate {
    func didUpdateWeather(
        _ weatherManager: WeatherManager, weather: WeatherModel) -> Void
    func didFailWithError(error: Error) -> Void
}

class WeatherManager {
    var delegate: WeatherDelegate?
    // parse JSON Data
    private let apiKey = Configuration.weatherApiKey
    private let url = "https://api.openweathermap.org/data/2.5/weather?"
    
    // fetch weather of lnt, lng
    func fetchWeather(_ lat: Float, lon: Float){
        let requestURL = "\(url)lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        performRequest(with: requestURL)
    }
    // fetchWeather of Location
    func fetchWeather(cityName: String){
        let requestURL = "\(url)q=\(cityName)&appid=\(apiKey)&units=metric"
        performRequest(with: requestURL)
    }
    
    func performRequest(with urlString: String){
        // 1. Create a URL
        guard let url = URL(string: urlString) else {
            return
        }
        // 2. Create a URLSession
        let session = URLSession(configuration: .default)
        // task is the one calling the handle() function in the completionHandler
        // it calls it when its done fetcqhing data -> datatask(Closure)
        // error processor
        let task = session.dataTask(with: url) { (data, response, error) in
            print("data")
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let data = data {
                print("parseJSON")
                if let weather = self.parseJSON(weatherData: data) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        // task start
        task.resume()
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        print("JSONParser")
        do {
            let decodeData : WeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            let weather =  WeatherModel(confitionID: id, cityName: name, temperature: temp)
            return weather
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
