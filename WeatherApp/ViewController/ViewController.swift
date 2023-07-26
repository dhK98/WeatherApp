import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - UIobj
    @IBOutlet weak var refreshButton: UIButton! {
        didSet {
            refreshButton.setImage(UIImage(systemName: "location"), for: .normal)
            refreshButton.setTitle("", for: .normal)
            refreshButton.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
            searchButton.setTitle("", for: .normal)
            searchButton.contentMode = .scaleAspectFit
        }
        
    }
    
    @IBOutlet weak var weatherImage: UIImageView! {
        didSet {
            weatherImage.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var cityTextField: UITextField! {
        didSet {
            cityTextField.textAlignment = .right
            cityTextField.backgroundColor = .white
            cityTextField.textColor = .black
        }
    }
    
    @IBOutlet weak var tempLabel: UILabel!{
        didSet {
            tempLabel.text = "0"
            tempLabel.font = UIFont.systemFont(ofSize: 30)
            tempLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var celsiusTextLabel: UILabel! {
        didSet {
            celsiusTextLabel.text = "°C"
            celsiusTextLabel.font = UIFont.systemFont(ofSize: 30)
            celsiusTextLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var cityNameLabel: UILabel! {
        didSet {
            cityNameLabel.font = UIFont.systemFont(ofSize: 30)
            cityNameLabel.text = "My City"
            cityNameLabel.textColor = .black
        }
    }
    
    @IBAction func refreshApplication(_ sender: Any) {
        changeRefreshButtonImageTemporarily()
        self.locationManager.startUpdatingLocation()
    }
    
    @IBAction func searchWeatherWithCityname(_ sender: Any) {
        changeSearchButtonImageTemporarily()
        self.searchForWeatherByCityname()
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
            self.cityTextField.delegate = self
            
            // 위치정보를 가져오는 코드
            self.getLocationUsagePermission()
        }
    }
    
    // MARK: - recycle function
    func searchForWeatherByCityname(){
        guard let cityName = self.cityTextField.text else {return}
        DispatchQueue.main.async {
            self.cityTextField.text = ""
        }
        if !cityName.isEmpty {
            self.weatherManager.fetchWeather(cityName: cityName)
        }
    }
    
    func changeRefreshButtonImageTemporarily(){
        refreshButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
            self.refreshButton.setImage(UIImage(systemName: "location"), for: .normal)
        }
    }
    
    func changeSearchButtonImageTemporarily(){
        searchButton.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
            self.searchButton.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        }
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // performance after click the textfield
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // performance after enter key
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        searchForWeatherByCityname()
        return true
    }
}


