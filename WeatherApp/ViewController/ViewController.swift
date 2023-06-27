import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: - UIobj
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var firstNumberLabel: UILabel! {
        didSet {
            firstNumberLabel.text = "0"
            firstNumberLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    @IBOutlet weak var secondNumberLabel: UILabel! {
        didSet {
            secondNumberLabel.text = "0"
            secondNumberLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    @IBOutlet weak var celsiusTextLabel: UILabel! {
        didSet {
            celsiusTextLabel.text = "°C"
            celsiusTextLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    @IBOutlet weak var cityNameLabel: UILabel! {
        didSet {
            cityNameLabel.font = UIFont.systemFont(ofSize: 10)
        }
    }
    
    @IBAction func refreshApplication(_ sender: Any) {
        
    }
    
    @IBAction func searchWeatherWithCityname(_ sender: Any) {
    }
    
    // MARK: - logic Manager
    var weatherManager: WeatherManager!
    var locationManager: CLLocationManager!
    
    // MARK: - load Memory
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "backgroundImage") {
            // 이미지를 표시할 CALayer를 생성합니다.
            let imageLayer = CALayer()
            imageLayer.contents = image.cgImage
                
            // 이미지 레이어의 프레임을 설정하여 이미지가 화면에 맞게 조절되도록 합니다.
            imageLayer.frame = self.view.bounds
                
            // 이미지 레이어를 self.view의 가장 아래에 추가합니다.
            self.view.layer.insertSublayer(imageLayer, at: 0)
            
            self.weatherManager = WeatherManager()
            self.locationManager = CLLocationManager()
            
            self.weatherManager.delegate = self
            self.locationManager.delegate = self
            
            // 위치정보를 가져오는 코드
            getLocationUsagePermission()
            
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else {
            print("권한 초기 설정")
            getLocationUsagePermission()
            return
        }
        
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation()
        case .restricted:
            print("GPS 권한 제한")
            getLocationUsagePermission()
        case .denied:
            print("GPS권한 요청 거부됨")
            showAuthorizationAlert()
        default:
            break
        }
    }
    
    func showAuthorizationAlert(){
        let alert = UIAlertController(title: "GPS 권한을 활성화 해주세요.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 가기", style: .default){ action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            
        })
        self.present(alert, animated: true)
    }
    
    func getLocationUsagePermission(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locationManager.stopUpdatingLocation()
            self.weatherManager.fetchWeather(Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
        }
       
    }
}

extension ViewController: WeatherDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // UI Obejct Update
        print("UI obejct updated \(weather.temperature)")
        return
    }
    
    func didFailWithError(error: Error) {
        print("Error Message: \(error)")
        return
    }
    
    
}
