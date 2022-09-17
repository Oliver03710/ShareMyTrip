//
//  CustomAnnotationView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            // Resize image
            let pinImage = UIImage(named: CustomAnnotations.one.images)
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
        
        // Enable callout
//        canShowCallout = true
        
        // Move the image a little bit above the point.
        centerOffset = CGPoint(x: 0, y: -20)
    }
}
