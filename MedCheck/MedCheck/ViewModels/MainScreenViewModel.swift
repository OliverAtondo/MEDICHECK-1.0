//
//  MainScreenViewModel.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 10/12/22.
//

import Foundation
import MapKit
import CoreLocationUI

class MainScreenViewModel: NSObject,ObservableObject, CLLocationManagerDelegate{
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    let locationManager = CLLocationManager()
    override init(){
        super.init()
        locationManager.delegate = self
    }
    func requestAllowOnceLocationPermission(){
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else{
            return
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

