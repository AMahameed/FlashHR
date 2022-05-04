//
//  MapsViewC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/1/22.
//

import UIKit
import GoogleMaps

protocol MapsViewCDelegate: AnyObject{
    func locationConfirmed(newLocation: CLLocation)
    func selectLocationCancelled()
}

class MapsViewC: UIViewController {
    
    
    @IBOutlet weak var getPlaceButton: UIButton!
    @IBOutlet weak var mapVV: GMSMapView!
    
    weak var delegate: MapsViewCDelegate?
    
    var selectedLocation: CLLocation?
    var marker: GMSMarker? {
        willSet {
            if newValue != nil {
                getPlaceButton.isEnabled = true
            } else {
                getPlaceButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlaceButton.isEnabled = false
        mapVV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let coordinates = CLLocationCoordinate2D(latitude: 31.970096, longitude: 35.842969)
        let camera = GMSCameraPosition(target: coordinates, zoom: 15, bearing: 0, viewingAngle: 0)
        mapVV.camera = camera
    }
    
    @IBAction func getPlacePressed(_ sender: UIButton) {
        if let location = selectedLocation {
            delegate?.locationConfirmed(newLocation: location)
        }else{
            presentAlert(message: "There was an error getting the desired Location")
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        delegate?.selectLocationCancelled()
        dismiss(animated: true)
    }
}

extension MapsViewC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if marker == nil {
            marker = GMSMarker(position: coordinate)
            DispatchQueue.main.async {
                self.marker?.map = self.mapVV
            }
        } else {
            marker?.position = coordinate
        }
        selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
}

