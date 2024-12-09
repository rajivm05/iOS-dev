//
//  Config.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/8/24.
//

import Foundation
struct Config{
    static let shared = Config()
    let googleMapsKey: String = "AIzaSyDjKxdklB2CVPqND2bep5I2xfmuLkUFE1E"
    let googleMapsBaseURL:String = "https://maps.googleapis.com/maps/api/geocode/json"
    
    //actual server
//    let serverURL: String = "https://distance-project-436721.uc.r.appspot.com"
    
    //test server
    let serverURL: String = "http://localhost:3000"
    let serverKey = 123456
    
    private init(){}
}
