//
//  TwitterFunction.swift
//  Weather-App-2
//
//  Created by Rajiv Murali on 12/11/24.
//

import Foundation
import UIKit

func renderTweetContent(city: String, temperature: Double, condition: String) -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let formattedDate = dateFormatter.string(from: currentDate)
    
    return "The temperature in \(city) on \(formattedDate) is \(Int(temperature))°F and the conditions are \(condition)"
}

func shareToTwitter(city: String, temperature: Double, condition: String) {
    let tweetText = renderTweetContent(city: city, temperature: temperature, condition: condition)
    let hashTag = "#CSCI571WeatherForecast"
    
    // Encode the tweet text for URL
    let encodedTweet = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let encodedHashTag = hashTag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    let urlString = "https://twitter.com/intent/tweet?text=\(encodedTweet)%20\(encodedHashTag)"
    
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}
