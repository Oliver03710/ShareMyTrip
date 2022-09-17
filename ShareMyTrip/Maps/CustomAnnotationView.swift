//
//  CustomAnnotationView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import MapKit

final class CustomAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            // Resize image
            // 이미지 원본을 집어넣으면 resizing 불필요?
            let pinImage = UIImage(named: CustomAnnotations.one.rawValue)
            let size = CGSize(width: 60, height: 85)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // Add Image
            self.image = resizedImage
            let anno = LocationHelper.standard.annotations[0]
            canShowCallout = true
            detailCalloutAccessoryView = Callout(annotation: anno)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        centerOffset = CGPoint(x: 0, y: -20)
    }
}
