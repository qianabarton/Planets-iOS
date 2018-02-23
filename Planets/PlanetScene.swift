//
//  Planets.swift
//  Planets
//
//  Created by Qiana Barton on 2/23/18.
//  Copyright © 2018 Qiana Barton. All rights reserved.
//

import Foundation
import UIKit

class PlanetScene {
    
    public var omniIntensity = 1400

    func setup(){
        

    }

    
    
    
    
    
    
    
    
    func loadPlanetStats(planet: String) -> String{
        var returnString = "hi"
        if let filepath = Bundle.main.path(forResource: "PlanetStats", ofType: "txt")
        {
            do
            {
                let contents = try String(contentsOfFile: filepath)
                let lines = contents.components(separatedBy: " [" + planet + "]\n")
                //why
                let str = lines[1]
                let intensity = str.index(str.startIndex, offsetBy: 4)
                omniIntensity = Int(Double(str.substring(to: intensity))!)
                
                let returnIndex = str.index(str.startIndex, offsetBy: 4)
                returnString = str.substring(from: returnIndex)
                print(returnString)
            }
            catch
            {
                print("PlanetStats.txt contents could not be loaded")
            }
        }
        else
        {
            print("PlanetStats.txt could not be found")
        }
        return returnString
    }
    
    

}
