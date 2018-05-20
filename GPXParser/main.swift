//
//  main.swift
//  GPXParser
//
//  Created by Maxime Brunengo on 20/05/2018.
//  Copyright © 2018 Maxime Brunengo. All rights reserved.
//

import Foundation

class Wpt {
    var lat: Float?;
    var long: Float?;
    var name = "";
    var time = "";
}

var gpx = [Wpt]();
var wpt = Wpt();
var foundCharacters = "";

class Parser: NSObject, XMLParserDelegate {
    
    func test(filepath: URL) {
        let parser = XMLParser(contentsOf: filepath)!
        parser.delegate = self
        let success = parser.parse()
        if success {
            print("done")
        }
        else {
            print(parser.parserError.debugDescription)
        }
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        
        foundCharacters = "";
        
        if elementName == "wpt" {

            if let lat = attributeDict["lat"] {
                wpt.lat = Float(lat);
            }
            
            if let long = attributeDict["lon"] {
                wpt.long = Float(long);
            }
            
        }
        
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        foundCharacters += string;
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        
        if elementName == "name" {
            wpt.name = foundCharacters;
        }
        
        if elementName == "time" {
            wpt.time = foundCharacters;
        }
        
        if elementName == "wpt" {
            let tempwpt = Wpt();
            tempwpt.lat = wpt.lat
            tempwpt.long = wpt.long
            tempwpt.name = wpt.name
            tempwpt.time = wpt.time
            gpx.append(tempwpt)
        }
        
        foundCharacters = "";
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for wpx in gpx {
            print(wpx.name)
            print(wpx.time)
            print(String(describing: wpx.lat))
            print(String(describing: wpx.long))
            print("\n")
        }
    }
    
}

var filepath = URL(fileURLWithPath: "/Users/maximebrunengo/Documents/GitHub/GPXParser/GPXParser/Location.gpx")

Parser().test(filepath: filepath)
