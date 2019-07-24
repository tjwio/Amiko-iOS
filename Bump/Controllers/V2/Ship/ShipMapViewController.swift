//
//  BAHistoryMapViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import MapKit
import ReactiveCocoa
import ReactiveSwift
import SDWebImage
import SnapKit

class ShipMapViewController: UIViewController, ShipController, MKMapViewDelegate {
    private struct Constants {
        static let annotationIdentifier = "BA_HISTORY_ANNOTATION_PIN_IDENTIFIER"
    }
    
    let user: User
    var ships: [Ship]
    
    weak var delegate: ShipViewTypeDelegate?
    
    let mapView = MKMapView()
    
    private var disposables = CompositeDisposable()
    
    init(user: User, ships: [Ship]) {
        self.user = user
        self.ships = ships.filter { !$0.pending }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposables.dispose()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleView = ListMapNavigationView()
        titleView.listButton.isSelected = false
        titleView.mapButton.isSelected = true
        navigationItem.titleView = titleView
        titleView.listButton.addTarget(self, action: #selector(self.switchToListView(_:)), for: .touchUpInside)
        
        addAnnotations()
        showAnnotations(mapView.annotations, animated: false)
        
        view.addSubview(mapView)
        
        setupConstraints()
        
        disposables += NotificationCenter.default.reactive.notifications(forName: .connectionAdded).observeValues { [unowned self] notification in
            self.ships = self.user.ships.filter { !$0.pending }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addAnnotations()
        }
        
        disposables += NotificationCenter.default.reactive.notifications(forName: .connectionDeleted).observeValues { [unowned self] notification in
            self.ships = self.user.ships.filter { !$0.pending }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addAnnotations()
        }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    // MARK: nav title
    
    @objc private func switchToListView(_ sender: UIButton?) {
        delegate?.shipControllerDidSwitchToListView(self)
    }
    
    //MARK: map delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationIdentifier) as? BAUserAnnotationView ?? BAUserAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationIdentifier)
        
        view.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        view.annotation = annotation
        if let imageUrl = (annotation as? UserPinAnnotation)?.ship.user.imageUrl {
            view.userImageView.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        }
        
        if let annotation = annotation as? UserPinAnnotation {
            view.layer.zPosition = annotation.isShowing ? 1.0 : 0.0
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? UserPinAnnotation {
            showAnnotations([annotation], animated: false)
        }
    }
    
    //MARK: map helper
    
    func showEntry(_ entry: Ship) {
        if let annotation = getAnnotation(forEntry: entry) {
            showAnnotations([annotation], animated: false)
        }
    }
    
    private func resetCenter(animated: Bool = false) {
        if let coordinate = user.ships.first?.coordinate ?? LocationManager.shared.currentLocation.value?.coordinate {
            mapView.setRegion(MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10.0, longitudinalMeters: 10.0), animated: animated)
            mapView.setCenter(coordinate, animated: animated)
        }
    }
    
    private func addAnnotations() {
        ships.forEach { ship in
            let annotation = UserPinAnnotation(ship: ship)
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
    
    private func getAnnotation(forEntry entry: Ship) -> MKAnnotation? {
        for annotation in mapView.annotations {
            if (annotation as? UserPinAnnotation)?.ship.id == entry.id {
                return annotation
            }
        }
        
        return nil
    }
}
