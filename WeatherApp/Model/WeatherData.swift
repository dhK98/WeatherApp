import Foundation

// 응답받은 JSON Decoding을 위한 구조체
struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
    
}
struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let  id: Int
}


