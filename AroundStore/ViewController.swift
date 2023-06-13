

import UIKit
import CoreLocation
import Foundation
import Alamofire

var category = "맛집"
var storeArray = [Store]()
    // load userdefault


struct Welcome: Codable {
    let meta: Meta
    let documents: [Document]
}

//Document(placeName: "농장사람들 보라매역점", distance: "", placeURL: "http://place.map.kakao.com/364531160", categoryName: "음식점 > 한식 > 육류,고기", addressName: "서울 영등포구 신길동 4206", roadAddressName: "서울 영등포구 여의대방로 115", id: "364531160", phone: "02-841-5488", categoryGroupCode: "FD6", categoryGroupName: "음식점", x: "126.919406649577", y: "37.4979315182181")

// distance 제외
  
// MARK: - Document
struct Document: Codable {
    let placeName, distance: String
    let placeURL: String
    let categoryName, addressName, roadAddressName, id: String
    let phone, categoryGroupCode, categoryGroupName, x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case distance
        case placeURL = "place_url"
        case categoryName = "category_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case id, phone
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case x, y
    }
}

// MARK: - Meta
struct Meta: Codable {
    let sameName: SameName
    let pageableCount, totalCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case sameName = "same_name"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case isEnd = "is_end"
    }
}

struct SameName: Codable {
    let region: [JSONAny]
    let keyword, selectedRegion: String

    enum CodingKeys: String, CodingKey {
        case region, keyword
        case selectedRegion = "selected_region"
    }
}



class ViewController: UIViewController, MTMapViewDelegate, MTMapReverseGeoCoderDelegate, CLLocationManagerDelegate {
    
    let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
    var address: String = ""
    
    let headers : HTTPHeaders = [
   
            "Content-Type": "application/json;charset=utf-8",
           "Authorization": "KakaoAK e9adc56fffa1c1eb749bc501435a51bd",
       ]

    func makeParameter(query : String, category_group_code : String, page: Int, size: Int) -> Parameters
    {
        return ["query": query,
                "category_group_code": category_group_code,
                "page": page,
                "size": size]
        
    }
    
    
    var dataSource = [Document]()

    @IBOutlet var kakaoMapUI: MTMapView!

    var mapView: MTMapView!
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
     
    public var geocoder: MTMapReverseGeoCoder!
    
    @IBOutlet var nowLocationBtn: UIButton!
    @IBOutlet var categoryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storeArrayData = UserDefaults.standard.data(forKey: "storeArray"),
            let data = try? JSONDecoder().decode([Store].self, from: storeArrayData) {
            storeArray = data
        }
        
        if let categoryData = UserDefaults.standard.string(forKey: "category") {
            category = categoryData
        }
        
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapView = MTMapView(frame: self.kakaoMapUI.frame)
        
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapView.showCurrentLocationMarker = false
            
//          mapView.currentLocationTrackingMode = .onWithoutHeading

            kakaoMapUI.addSubview(mapView)
            
        }
        
    
        
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == .authorizedAlways ||  locationManager.authorizationStatus == .authorizedWhenInUse{
                print("위치 on")
            } else {
                print("위치 off")
            }
        } else {
            // Fallback on earlier versions
        }
        
        nowLocationBtn.setTitle("", for: .normal)
        nowLocationBtn.setImage(UIImage(named: "nowlocation"), for: .normal)
        nowLocationBtn.contentVerticalAlignment = .fill
        nowLocationBtn.contentHorizontalAlignment = .fill
        nowLocationBtn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        nowLocationBtn.layer.cornerRadius = 30
        
        categoryBtn.setTitle("", for: .normal)
        categoryBtn.setImage(UIImage(named: "category"), for: .normal)
        categoryBtn.contentVerticalAlignment = .fill
        categoryBtn.contentHorizontalAlignment = .fill
        categoryBtn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        categoryBtn.layer.cornerRadius = 30
        
 
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }

    
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus

        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
           // guard locationManager.authorizationStatus == .authorizedAlways else {
                // 시스템 설정으로 유도하는 커스텀 얼럿
                self.showRequestLocationServiceAlert()
                return
            }
        }
        // 3.2
      
            
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
            
        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태

            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
    
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(#function)
     }

     
     // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            async { await self?.reloadInputViews() }
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("현재위치: \(location.coordinate.latitude)")
            print("현재위치: \(location.coordinate.longitude)")
            
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)), zoomLevel: 2, animated: true)
        }
        
        
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    
    
    
    
    
    // Custom: 현 위치 트래킹 함수
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        
 
        DispatchQueue.global().async {
            self.mapView.currentLocationTrackingMode = .off
            self.mapView.showCurrentLocationMarker = false
        }
        
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
        
        }

    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        
       
        let geocoder = MTMapReverseGeoCoder(
            mapPoint: MTMapPoint(geoCoord: MTMapPointGeo(latitude: mapCenterPoint.mapPointGeo().latitude, longitude: mapCenterPoint.mapPointGeo().longitude)),
            with: self, withOpenAPIKey: "c751911416abee20762cfe09e9ca0942")
    
        self.geocoder = geocoder
        geocoder?.startFindingAddress()
        
    }
    
    
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        guard let addressString = addressString else { return }
        address = addressString
        
        mapView.removeAllPOIItems()
        search()
        
     
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        print(poiItem.itemName)
        print(poiItem.mapPoint)
    
        print(dataSource[poiItem.tag].placeName)
        print(dataSource[poiItem.tag].y)
        print(dataSource[poiItem.tag].x)
        print(dataSource[poiItem.tag].addressName)
        

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "popup") as! PopUpVC
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.placeName = dataSource[poiItem.tag].placeName
        vc.placeURL = dataSource[poiItem.tag].placeURL
        
        vc.categoryName = dataSource[poiItem.tag].categoryName
        vc.addressName = dataSource[poiItem.tag].addressName
        vc.roadAddressName = dataSource[poiItem.tag].roadAddressName
        
        vc.id = dataSource[poiItem.tag].id
        vc.phone = dataSource[poiItem.tag].phone
        
        vc.categoryGroupCode = dataSource[poiItem.tag].categoryGroupCode
        vc.categoryGroupName = dataSource[poiItem.tag].categoryGroupName

        vc.x = dataSource[poiItem.tag].y
        vc.y = dataSource[poiItem.tag].x
        
        self.present(vc, animated: false)
      
        return false
    }
    
    func search() {
        
        AF.request(url,
                   method: .get,
                   parameters: makeParameter(query: "\(address) \(category)", category_group_code: "FD6", page: 1, size: 15),
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            //여기서 가져온 데이터를 자유롭게 활용하세요.
           
            switch response.result {
            case .success(let res):
                let resultData = String(data: response.data!, encoding: .utf8)
                print(self.address)
                //print(resultData)
                do {
                    // 반환값을 Data 타입으로 변환
                    print("1")
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    print("2")
                    let json = try JSONDecoder().decode(Welcome.self, from: jsonData)
                    print("3")
                    self.dataSource = json.documents
                    print("4")
                    for i in 0..<self.dataSource.count {
//                        print(self.dataSource[i].placeName)
//                        print(self.dataSource[i])
//                        print(Double(self.dataSource[i].y)!)
//                        print(Double(self.dataSource[i].x)!)
                        
                        let pointItem = MTMapPOIItem()
                        let geocoder = MTMapReverseGeoCoder(
                            mapPoint:  MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(self.dataSource[i].y)!, longitude: Double(self.dataSource[i].x)!)), with: self, withOpenAPIKey: "c751911416abee20762cfe09e9ca0942")
                        pointItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(self.dataSource[i].y)!, longitude: Double(self.dataSource[i].x)!))
                        pointItem.itemName = self.dataSource[i].placeName
                        
                        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)

                        pointItem.customImage = UIImage(named: "map_pin_red")
                    
                        pointItem.markerType = MTMapPOIItemMarkerType.customImage
                        
                        pointItem.tag = i
                        
                        self.mapView.add(pointItem)
                  
                    }
                  
                    
                    
                    
                } catch (let error) {
                    print("catch error : \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
            
            
        }
    }
    
    
    @IBAction func nowLocationBtnWasPressed(_ sender: Any) {

        DispatchQueue.global().async {
            self.mapView.currentLocationTrackingMode = .onWithoutHeading
        }
        self.mapView.showCurrentLocationMarker = false
        
    }
    
    
    @IBAction func categoryBtnWasPressed(_ sender: Any) {
       
        let cateVC = self.storyboard?.instantiateViewController(withIdentifier: "cateVC") as? CategoryVC

        cateVC!.modalPresentationStyle = .fullScreen
        cateVC?.selectedCategory = category
        
        self.navigationController?.pushViewController(cateVC!, animated: true)

    }
    
    
    
}




