//
//  main.swift
//  test Performance
//
//  Created by Roman Mishchenko on 16.11.2019.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import Foundation





var countries: [Country] = []

let timeNano1 = CFAbsoluteTimeGetCurrent()
let path = "countryRegex.txt"
var text = ""

let pattern = #"(?:region|\G)>(?<region>\b[a-zA-Z]+)<(?:country|\G)>(?<country>\b[a-zA-Z]+)<(?:flag_url|\G)><(?<url>\b.+)>"#
let regex = try! NSRegularExpression(pattern: pattern, options: [])
let nsrange = NSRange(text.startIndex..<text.endIndex,
                      in: text)
let url1 = URL(fileURLWithPath: path)
do {
    text = try String(contentsOf: url1)
    let matches = regex.matches(in: text, options: [], range: nsrange)
        
    for match in matches {
        var country: Country = Country(name: "", region: "", url: "")
        
        var nsrange = match.range(withName: "region")
        let range = Range(nsrange, in: text)
        country.region = "\(text[range!])"
        
        nsrange = match.range(withName: "country")
        let range2 = Range(nsrange, in: text)
        country.region = "\(text[range2!])"
        
        nsrange = match.range(withName: "url")
        let range3 = Range(nsrange, in: text)
        country.region = "\(text[range3!])"
        
        countries.append(country)
    }
} catch {
    print("Ooops! Something went wrong: \(error)")
}

let timeNano2 = CFAbsoluteTimeGetCurrent()
print("Сколько прошло времени: \(timeNano2 - timeNano1)")


var countriesJSON: [Country] = []
let timeNano3 = CFAbsoluteTimeGetCurrent()

let path2 = "countryJSON.txt"
let url = URL(fileURLWithPath: path2)
do {
    let data = try Data(contentsOf: url)
    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    let array = json as! [Any]
    for country in array {
        let countryDict = country as! [String: Any]
        let country = Country(name: countryDict["country"] as! String, region: countryDict["region"] as! String, url: countryDict["flag_url"] as! String)
        countriesJSON.append(country)
    }
    
} catch {
    print("Ooops! Something went wrong: \(error)")
}

let timeNano4 = CFAbsoluteTimeGetCurrent()
print("Сколько прошло времени для JSON: \(timeNano4 - timeNano3)")



print("ended")
