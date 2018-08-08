//
//  BAHistoryMapViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class BAHistoryMapViewController: UIViewController, MKMapViewDelegate {
    
    private struct Constants {
        static let annotationIdentifier = "BA_HISTORY_ANNOTATION_PIN_IDENTIFIER"
    }
    
    let mapView = MKMapView()
    
    let user: BAUser
    
    init(user: BAUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        resetCenter()
        addAnnotations()
        
        view.addSubview(mapView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    //MARK: map delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationIdentifier) as? BAUserAnnotationView ?? BAUserAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationIdentifier)
        
        view.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        view.annotation = annotation
        if let annotation = annotation as? BAUserPinAnnotation {
            annotation.user?.loadImage(success: { image in
                view.userImageView.imageView.image = image
            }, failure: nil)
        }
        
        return view
    }
    
    //MARK: map helper
    
    private func resetCenter() {
        if let coordinate = user.history.first?.coordinate ?? BALocationManager.shared.currentLocation?.coordinate {
            mapView.setCenter(coordinate, animated: true)
        }
    }
    
    private func addAnnotations() {
        for entry in user.history {
            let annotation = BAUserPinAnnotation(coordinate: entry.coordinate, user: entry.addedUser)
            mapView.addAnnotation(annotation)
        }
    }
}
