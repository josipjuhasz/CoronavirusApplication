//
//  Coordinator.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 12.05.2022..
//

import SwiftUI
import MapKit

class MapManager: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    let parentView: MapView
    
    private var gestureRecognizer = UITapGestureRecognizer()
    private let locationManager = LocationManager()
    var enableTapGesture = false
    
    init(_ map: MapView) {
        self.parentView = map
        super.init()
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.gestureRecognizer.delegate = self
        self.parentView.mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if parentView.viewModel.domainItem?.title == "Worldwide" {
                parentView.viewModel.updateDomain(annotation: annotation)
                enableTapGesture = true
            }
            else {
                if (UIApplication.shared.canOpenURL(URL(string:"maps://")!)) {
                    if let location = locationManager.lastLocation?.coordinate {
                        if let url = URL(string: "maps://?saddr=\(location.latitude),\(location.longitude)&daddr=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }}
                }
            }
        }
    }
    
    @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
        if enableTapGesture {
            parentView.viewModel.onUseCaseSelectionChange(.country("india"))
            parentView.viewModel.onUseCaseSelectionChange(.worldwide)
            enableTapGesture = false
        }
    }
}
