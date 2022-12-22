# 여행가자곰 (앱 출시 완료)
<p align="center">
<img src="https://user-images.githubusercontent.com/105812328/208724326-d5a7dd71-5d55-4727-b049-27b47f492c6b.PNG" width="15%" height="30%">
<img src="https://user-images.githubusercontent.com/105812328/208724349-95ff1d04-1aa5-4c2e-84d1-c955e18447ed.PNG" width="15%" height="30%">
<img src="https://user-images.githubusercontent.com/105812328/208724532-a9bc7d4d-e903-4100-8fa1-e9c18740f298.PNG" width="15%" height="30%">
<img src="https://user-images.githubusercontent.com/105812328/208724663-ff03fa2b-e36d-48f1-b089-1a4065258389.PNG" width="15%" height="30%">
<img src="https://user-images.githubusercontent.com/105812328/208724740-04763d2c-7cae-49c2-b941-ed85a696de37.PNG" width="15%" height="30%">
<img src="https://user-images.githubusercontent.com/105812328/208724779-4b7df0f0-8d82-441e-9638-7ce36d565c0f.PNG" width="15%" height="30%">
</p>

[여행가자곰 앱스토어 링크](https://apps.apple.com/kr/app/%EC%97%AC%ED%96%89%EA%B0%80%EC%9E%90%EA%B3%B0/id6443563655)

## 앱 소개
- 내가 가고 싶은 목적지를 검색 및 등록하고, 목적지간 경로를 한눈에 확인할 수 있는 여행 플래너   

## 앱의 주요 기능
- 카카오의 키워드 검색 API활용하여 내가 가고 싶은 목적지를 검색하는 기능
- MKPointAnnotation과 MKAnnotationView로 Custom Annotation 이미지 생성하고 목적지에 표시
- MKGradientPolylineRenderer를 통해 각 목적지 간의 경로 보기
- 전국관광지정보표준데이터 API와 CLCircularRegion을 활용하여 목적지 반경 10km 내 추천 관광지 표시
- CompositionalLayout, DiffableDataSource를 기반으로 생성한 Collection View로 여행 동료 목록 관리
- Realm Object의 PK를 통해 중복되는 데이터를 관리
- superEncoder / nestedContainer를 활용한 json 백업 및 복구 기능
- MessageUI 프레임워크와 MFMailComposeViewController 인스턴스를 통해 문의 사항 제출 기능

## 프로젝트 진행기간
- 22\. 09. 13. ~ 22. 10. 02. (약 3주)
- 지속적으로 업데이트 중

## 프로젝트에 사용한 기술스택
| 애플 프레임워크 | 디자인 | 디자인패턴 | 오픈 라이브러리 |
| :----: | :----: | :----: | :----: |
| CoreLocation | AutoLayout | Delegate | AcknowList |
| Foundation |  | MVC | FirebaseAnalyticsWithADidSupport |
| MapKit |  | MVVM | FirebaseCrashlytics |
| MessageUI |  | Repository | FirebaseMessaging |
| UIKit |  | Singleton | PanModal |
|  |  | | Realm |
|  |  | | SnapKit |
|  |  | | Toast |
|  |  | | Zip |

## 트러블슈팅
<p align="center">
<img src="https://user-images.githubusercontent.com/105812328/208724532-a9bc7d4d-e903-4100-8fa1-e9c18740f298.PNG" width="30%" height="40%">
</p>

- 커스텀 어노테이션 이미지의 재사용 문제
1~50까지의 Int값을 가진 이미지를 어노테이션을 생성하며 해당 목적지 순번에 맞게 mapView에 AddOverlay했지만, mapView의 region을 이동시켰다가 다시 어노테이션 있는 곳으로 region을 이동시킬 경우, 모두 같은 Int값을 가지는 이미지로 교체되는 문제 발생

<br/>

\-> 커스텀 어노테이션을 만들고 각 이미지마다 Int타입의 ID를 생성, 해당 ID마다 같은 Int값을 가지는 이미지 할당
```swift
// 커스텀 어노테이션 생성
final class Annotation: MKPointAnnotation {
    var identifier: Int
    
    init(_ identifier: Int) {
        self.identifier = identifier
    }
}

// 뷰컨트롤러의 어노테이션 생성하는 부분에서 ID에 맞는 이미지를 지정 및 생성
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "\(annotation.identifier)")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "\(annotation.identifier)")
        } else {
            annotationView?.annotation = annotation
        }
        let currentTrip = TripHistoryRepository.standard.fetchTrips(.current)
        
        viewModel.isExecutedFunc(identifier: annotation.identifier, taskOrder: currentTrip[0].trips.count - 1, annotationView: annotationView, annotation: annotation)

        return annotationView
    }
```
<br/>

- 경로를 계산하고 배열에 담는 과정에서 배열의 순번이 꼬여 mapView에 addOverlay했을 때, 목적지 간의 경로가 뒤엉키는 문제
<br/>

\-> 경로를 딕셔너리 타입으로 변경 후, Key값에 목적지 순번을, Value값에 경로를 배치하여 맵뷰에 addOverlay시 경로 순서가 꼬이지 않도록 수정
```swift
func createPath(_ mapView: MKMapView, sourceLat: CLLocationDegrees, sourceLon: CLLocationDegrees, destinationLat: CLLocationDegrees, destinationLon: CLLocationDegrees, turn: Int, status: TripStatus) {
	    // 여행 경로를 계산
        let direction = MKDirections(request: directionRequest)
        direction.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error Found: \(error.localizedDescription)")
                }
                return
            }
            
			// 계산한 여행 경로를 경로를 관리하는 딕셔너리에 업데이트
            switch status {
            case .current:
                self.routes.updateValue(response.routes[0], forKey: turn)
            case .past:
                self.historyRoutes.updateValue(response.routes[0], forKey: turn)
            }
        }
    }
```
<br/>

- 배열을 가지고 있는 Realm 데이터를 json으로 변환하여 데이터 백업 및 복구 기능 구현 문제
Realm Object를 json으로 Encoding하여 외부로 Export할 때는 Realm의 List타입을 Array나 Dictionary처럼 애플 Framework에 있는 Collection타입으로 변경하고 json으로 Encoding해야 하는 것으로 잘못이해
<br/>

\-> superEncoder 및 nestedContainer 키워드를 사용하여 json으로 내보내고 복구하는 기능 구현
```swift
    // 데이터를 json 인코딩해서 외부로 내보낼 때 superEncoder 활용
    func encode(to encoder: Encoder) throws {

		// superEncoder를 통해 배열을 만들어주고 내부에 데이터 삽입
        let tripsContainer = container.superEncoder(forKey: .trips)
        try trips.encode(to: tripsContainer)
    }
    
	// json으로 저장한 데이터를 불러올 때 nestedContainer 활용
    required convenience init(from decoder: Decoder) throws {
    
		// nestedUnkeyedContainer로 배열 데이터에 접근
        var companiesContainer = try container.nestedUnkeyedContainer(forKey: .companions)
        
		// 반복문을 통해 json데이터 배열을 decoding한 후 빈 배열에 저장
        var compArray = [(companion: String, isBeingDeleted: Bool)]()
        while !companiesContainer.isAtEnd {
            let itemCountContainer = try companiesContainer.nestedContainer(keyedBy: CompanionsCodingKeys.self)
            let companion = try itemCountContainer.decode(String.self, forKey: .companion)
            let isBeingDeleted = try itemCountContainer.decode(Bool.self, forKey: .isBeingDeleted)
            compArray.append((companion, isBeingDeleted))
        }
        
		// decoding한 데이터를 저장하려는 Realm Object 타입으로 변환하여 저장
        compArray.forEach {
            self.companions.append(Companions(companion: $0.companion, isbeingDeleted: $0.isBeingDeleted))
        }
    }
```
<br/>

<p align="center">
<img src="https://user-images.githubusercontent.com/105812328/208724532-a9bc7d4d-e903-4100-8fa1-e9c18740f298.PNG" width="30%" height="40%">
<img src="https://user-images.githubusercontent.com/105812328/208724779-4b7df0f0-8d82-441e-9638-7ce36d565c0f.PNG" width="30%" height="40%">
</p>

- 데이터 복구하는 과정에서 기존 데이터 삭제시, mapView에 add된 데이터 삭제 순서에 따른 오류    
더보기 탭에서 복구셀을 tap했을 때, 기존에 mapView에 올라간 overlay들을 모두 삭제하고 외부에 저장한 json 백업 파일을 덮어써야 했습니다.
이 과정에서 mapView 인스턴스를 전달하여 더보기 탭에서 mapView Overlay데이터를 삭제해야 하는데, 인스턴스를 성공적으로 전달하기 위해서는 반드시 맵뷰가 있는 뷰컨트롤러의 transition이 필요하여 복구기능이 부자연스럽게 진행되었습니다.
NotificationCenter를 활용해보았지만, 유저가 앱을 최초에 실행하고 바로 더보기 탭으로 이동할 경우 Notification Center에 인스턴스가 전달되지 않았습니다. 반드시 지도 탭을 클릭했을 때, 인스턴스가 전달하는 것을 확인했습니다.
<br/>

\-> Delegate와 PanModal 라이브러리를 활용하여 인스턴스를 전달하고 뷰를 transition할 때, safeArea 바깥쪽으로 Present하도록하여 뷰 컨트롤러가 화면에 보이지 않게 하면서 인스턴스를 전달하여 해결했습니다.
```swift
// Delegate패턴을 활용하여 mapView Instance 전달
protocol TransferMapViewDelegate: AnyObject {
    func passMapView(_ mapView: MKMapView)
}

final class MapViewController: BaseViewController {

		// Delegate패턴을 활용하여 mapView Instance 전달
		weak var delegate: TransferMapViewDelegate?

		override func configureUI() {
		// Delegate패턴을 활용하여 mapView Instance 전달
        delegate?.passMapView(self.mapView)
    }
}

// 복구시 MapViewController의 Present Setting
extension MapViewController: PanModalPresentable {

    // Present할 때 safeArea 안쪽으로 보이지 않도록 높이 조절
    var shortFormHeight: PanModalHeight {
        return .contentHeightIgnoringSafeArea(0)
    }

    var longFormHeight: PanModalHeight {
        return shortFormHeight
    }
}

extension BackupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlertMessageWithCancel(title: "해당 데이터로 복구하시겠습니까?") {
            do {
                // '복구'셀을 클릭했을 때 MapViewController 생성 후, delegate 세팅 및 뷰컨트롤러 present
                let mv = MapViewController()
                mv.delegate = self
                self.presentPanModal(mv)
            } catch {
                print(error)
            }
        }
    }
}

// 전달받은 mapView Instance를 통해서 mapView Overlay 모두 삭제
extension BackupViewController: TransferMapViewDelegate {
    func passMapView(_ mapView: MKMapView) {
        LocationHelper.standard.removeAnnotations(mapView, status: .current)
        LocationHelper.standard.routes.removeAll()
        mapView.removeOverlays(mapView.overlays)
    }
}
```
