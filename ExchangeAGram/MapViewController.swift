//
//  MapViewController.swift
//  ExchangeAGram
//
//  Created by Kenneth Wilcox on 2/8/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let location = CLLocationCoordinate2D(latitude: 48.868639224587, longitude: 2.37119161036255)
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: location, span: span)
    mapView.setRegion(region, animated: true)
    
    let annotation = MKPointAnnotation()
    annotation.setCoordinate(location)
    annotation.title = "Canal Saint-Martin"
    annotation.subtitle = "Paris"
    mapView.addAnnotation(annotation)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
