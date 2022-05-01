//
//  GoogleMapsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 4/30/22.
//

import UIKit
import GoogleMaps

protocol GoogleMapsVCDelegate: AnyObject{
    func locationConfirmed(newLocation: CLLocation)     //used protocol
    func selectLocationCancelled()
}

class GoogleMapsVC: UIViewController {
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    weak var delegate: GoogleMapsVCDelegate? // Delegate
    
    var selectedLocation: CLLocation?
    var marker: GMSMarker? {
        willSet {
            if newValue != nil {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        googleMap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let coordinates = CLLocationCoordinate2D(latitude: 31.970096, longitude: 35.842969)
        let camera = GMSCameraPosition(target: coordinates, zoom: 15, bearing: 0, viewingAngle: 0)
        googleMap.camera = camera
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.delegate?.selectLocationCancelled()                   // calling the protocol method
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if let location = selectedLocation {
            self.delegate?.locationConfirmed(newLocation: location)  // calling the protocol method
        }else{
            presentAlert(message: "There was an error getting the desired Location")
        }
        dismiss(animated: true)
    }
    
}

//MARK: - GMSMapViewDelegate

extension GoogleMapsVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if marker == nil {
            marker = GMSMarker(position: coordinate)
            DispatchQueue.main.async {
                self.marker?.map = self.googleMap
            }
        } else {
            marker?.position = coordinate
        }
        selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}



