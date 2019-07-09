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

class BAHistoryMapViewController: UIViewController, BAHistoryViewController, MKMapViewDelegate {
    
    private struct Constants {
        static let annotationIdentifier = "BA_HISTORY_ANNOTATION_PIN_IDENTIFIER"
    }
    
    weak var delegate: BAHistoryChangeDelegate?
    
    let user: User
    
    let mapView = MKMapView()
    
    var bottomOffset: CGFloat = 600.0 {
        didSet {
            if viewIfLoaded?.window != nil {
                let delta = oldValue - bottomOffset
                if delta > 0 {
                    zoomMapOut(top: delta * 0.8)
                }
                else {
                    zoomMapOut(bottom: abs(delta * 1.8))
                }
            }
        }
    }
    
    init(user: User, delegate: BAHistoryChangeDelegate? = nil) {
        self.user = user
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addAnnotations()
        showFirstAnnotation()
        
        view.addSubview(mapView)
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zoomMapOut(bottom: bottomOffset)
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
        if let annotation = annotation as? UserPinAnnotation {
            annotation.history?.addedUser.loadImage(success: { (image, _) in
                view.userImageView.imageView.image = image
            }, failure: { _ in
                view.userImageView.imageView.image = .blankAvatar
            })
        }
        
        if let annotation = annotation as? UserPinAnnotation {
            view.layer.zPosition = annotation.isShowing ? 1.0 : 0.0
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? UserPinAnnotation, let entry = annotation.history {
            showAnnotations([annotation], animated: false)
            zoomMapOut(bottom: bottomOffset)
            delegate?.historyController(self, didSelect: entry)
        }
    }
    
    //MARK: map helper
    
    func showEntry(_ entry: BAHistory) {
        if let annotation = getAnnotation(forEntry: entry) {
            showAnnotations([annotation], animated: false)
            zoomMapOut(bottom: bottomOffset)
        }
    }
    
    private func resetCenter(animated: Bool = false) {
        if let coordinate = user.history.first?.coordinate ?? LocationManager.shared.currentLocation?.coordinate {
            mapView.setRegion(MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10.0, longitudinalMeters: 10.0), animated: animated)
            mapView.setCenter(coordinate, animated: animated)
        }
    }
    
    private func addAnnotations() {
        for entry in user.history {
            let annotation = UserPinAnnotation(coordinate: entry.coordinate, history: entry)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func showAnnotations(_ annotations: [MKAnnotation], animated: Bool) {
        mapView.annotations.forEach { annotation in
            if let annotation = annotation as? UserPinAnnotation {
                if annotation.isShowing {
                    mapView.view(for: annotation)?.layer.zPosition = 0.0
                    annotation.isShowing = false
                }
            }
        }
        
        mapView.showAnnotations(annotations, animated: animated)
        
        annotations.forEach { annotation in
            if let annotation = annotation as? UserPinAnnotation {
                mapView.view(for: annotation)?.layer.zPosition = 1.0
                annotation.isShowing = true
            }
        }
    }
    
    private func showFirstAnnotation(animated: Bool = false) {
        if let entry = user.history.first, let annotation = getAnnotation(forEntry: entry) {
            showAnnotations([annotation], animated: animated)
        }
    }
    
    private func zoomMapOut(top: CGFloat = 0.0, bottom: CGFloat = 0.0, animated: Bool = true) {
        mapView.setVisibleMapRect(mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: top, left: 0.0, bottom: bottom, right: 0.0), animated: true)
    }
    
    private func getAnnotation(forEntry entry: BAHistory) -> MKAnnotation? {
        for annotation in mapView.annotations {
            if (annotation as? UserPinAnnotation)?.history?.addedUser === entry.addedUser {
                return annotation
            }
        }
        
        return nil
    }
}