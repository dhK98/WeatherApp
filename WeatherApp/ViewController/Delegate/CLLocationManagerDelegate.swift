import UIKit
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        guard status != .notDetermined else {
//            print("권한 초기 설정")
//            getLocationUsagePermission()
//            return
//        }
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
                self.locationManager.startUpdatingLocation()
            case .restricted:
                print("GPS 권한 제한")
                getLocationUsagePermission()
            case .denied:
                print("GPS 권한 요청 거부됨")
                showAuthorizationAlert()
            case .notDetermined:
                print("권한 초기 설정")
                getLocationUsagePermission()
            @unknown default:
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
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locationManager.stopUpdatingLocation()
            self.weatherManager.fetchWeather(Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError("not load location infomation")
    }
}
