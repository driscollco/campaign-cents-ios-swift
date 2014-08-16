//
//  MapViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/16/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var kochMap: MKMapView!
    @IBOutlet var kochPoliticiansNationwide: UILabel!
    
    // Geographic center of the contiguous United States: http://en.wikipedia.org/wiki/Geographic_center_of_the_contiguous_United_States
    var latSelected:Double = 39.50
    var lngSelected:Double = -98.35
    
    // Defaults to Country Level zoom
    var deltaSelected:Double = 60.0
    
    var politician = Dictionary<String, String>()
    
    var politicians = [
        [
            "name" : "Ted Cruz",
            "position" : "U.S. Senator",
            "party" : "R",
            "lat" : "30.269402",
            "lng" : "-97.739141",
            "state" : "TX",
            "lifetimeFunding" : "$230,000",
            "photo" : "Cruz, Ted.png"
        ],
        [
            "name" : "Roger Williams",
            "position" : "U.S. Representative",
            "party" : "R",
            "lat" : "30.272060",
            "lng" : "-97.740949",
            "state" : "TX",
            "lifetimeFunding" : "$107,000",
            "photo" : "Williams, Roger.png"
        ],
        [
            "name" : "Samuel Frederickson",
            "position" : "U.S. Representative",
            "party" : "D",
            "lat" : "30.232060",
            "lng" : "-97.720949",
            "state" : "TX",
            "lifetimeFunding" : "$237,000",
            "photo" : "Frederickson, Samuel.png"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kochMap.delegate = self
        
        var latLocation:CLLocationDegrees = latSelected
        var lngLocation:CLLocationDegrees = lngSelected
        
        var coordDelta:CLLocationDegrees = deltaSelected
        
        var selectedSpan:MKCoordinateSpan = MKCoordinateSpanMake(coordDelta, coordDelta)
        
        var selectedLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latLocation, lngLocation)
        var selectedRegion:MKCoordinateRegion = MKCoordinateRegionMake(selectedLocation, selectedSpan)

        kochMap.setRegion(selectedRegion, animated: true)

        kochPoliticiansNationwide.text = "Koch Politicians Nationwide: \(politicians.count)"

        for var i = 0; i < politicians.count; i++ {
            var politician = MKPointAnnotation()
            
            var politicianLifetimeFunding:String = politicians[i]["lifetimeFunding"]! as String
            
            // Converts string to "double" data type
            var lat = NSString(string: politicians[i]["lat"]).doubleValue
            var lng = NSString(string: politicians[i]["lng"]).doubleValue
            
            politician.coordinate = CLLocationCoordinate2DMake(lat as CLLocationDegrees, lng as CLLocationDegrees)
            politician.title = politicians[i]["name"]! as String
            politician.subtitle = "Lifetime Funding: \(politicianLifetimeFunding)"
            
            kochMap.addAnnotation(politician)
        }
    }

    // Delegate method called each time an annotation appears in the visible window
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Red
            
            for var i = 0; i < politicians.count; i++ {
            /*
                // NOT WORKING: Pin color differs based on political party affiliation
                if politicians[i]["party"] == "R" {
                    pinView!.pinColor = .Red
                } else if politicians[i]["party"] == "D"{
                    pinView!.pinColor = .Green
                } else {
                    pinView!.pinColor = .Purple
                }
            */

                if annotation.title == politicians[i]["name"] {
                    var imageview = UIImageView(frame: CGRectMake(0, 0, 45, 45))
                    imageview.image = UIImage(named: politicians[i]["photo"])
                    pinView!.leftCalloutAccessoryView = imageview
                }
            }
            
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
