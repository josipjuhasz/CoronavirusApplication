//
//  MKMapView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 07.05.2022..
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    let viewModel: MapViewModel
    let mapView = MKMapView()
    
    init(viewModel: MapViewModel){
        self.viewModel = viewModel
    }
    
    func makeUIView(context: Context) -> some MKMapView {
        return mapView
    }
    
    func makeCoordinator() -> MapManager {
        MapManager(self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        mapView.delegate = context.coordinator
        if let domain = viewModel.domainItem {
            if domain.title == "Worldwide" {
                setWorldwideUseCase(uiView: uiView, context: context)
            }
            else {
                setCountryUseCase(uiView: uiView, context: context)
            }
        }
    }
}

extension MapView {
    func setWorldwideUseCase(uiView: UIViewType, context: Context) {
        if let domain = viewModel.domainItem,
           let country = domain.worldwideItems?.first?.name {
            uiView.removeAnnotations(uiView.annotations)
            setRegion(uiView: uiView, country: country)
            
            if let countries = domain.worldwideItems {
                for coordinate in countries {
                    let annotation = MKPointAnnotation()
                    annotation.title = coordinate.name
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(coordinate.lat) ?? 0.0, longitude: Double(coordinate.lon) ?? 0.0)
                    uiView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func setCountryUseCase(uiView: UIViewType, context: Context) {
        if let domain = viewModel.domainItem,
           let country = domain.title {
            setRegion(uiView: uiView, country: country)
            
            let annotation: MKPointAnnotation = MKPointAnnotation()
            uiView.removeAnnotations(uiView.annotations)
            
            if let countries = domain.countryCoordinates {
                for item in countries {
                    annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                }
                annotation.title = domain.title
                uiView.addAnnotation(annotation)
            }
        }
    }
    
    private func setRegion(uiView: UIViewType, country: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "\(country)"
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let response = response else { return }
            
            uiView.setRegion(response.boundingRegion, animated: true)
        }
    }
}

