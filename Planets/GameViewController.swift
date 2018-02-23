//
//  GameViewController.swift
//  Planets
//
//  Created by Qiana Barton on 11/1/17.
//  Copyright © 2017 Qiana Barton. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var planetName: UILabel!
    @IBOutlet weak var planetStats: UILabel!
    
    var scnScene: SCNScene!
    var cameraNode: SCNNode!

    var planetNode: SCNNode!
    var sunNode: SCNNode!
    var omni: SCNLight!
    
    var planet = "Earth"
    var omniIntensity = 1400
    var menuVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()

        setupCamera()
        setupLight()
        setupSun()
        
        spawnPlanet(planet: planet)
        setLabels(planet: planet)
    }
    
    func setupView() {
        //scnView = self.view as SCNView
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = false
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnScene.background.contents = "objects.scnassets/Textures/Backgrounds/galaxy_crop.png"
    }
    
    func setupLight(){
        let omniNode = SCNNode()
        omniNode.position = SCNVector3(x: 3, y: 2, z: 3)

        omni = SCNLight()
        omniNode.light = omni
        omni.type = SCNLight.LightType.omni
        omni.intensity = CGFloat(omniIntensity)
        omni.color = UIColor.white
        scnScene.rootNode.addChildNode(omniNode)
        
        let ambientNode = SCNNode()
        ambientNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        let ambient = SCNLight()
        ambientNode.light = ambient
        ambient.type = SCNLight.LightType.ambient
        ambient.color = UIColor.white
        ambient.intensity = 700
        scnScene.rootNode.addChildNode(ambientNode)
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func setupSun(){
        let ball = SCNSphere(radius: 1.0)
        sunNode = SCNNode()
        sunNode.geometry = ball
        sunNode.position = SCNVector3(x: -1, y: 2, z:1.5)
        sunNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        
        //scnScene.rootNode.addChildNode(sunNode)
    }
    
    func spawnPlanet(planet: String) {
        let ball = SCNSphere(radius: 1.0)
        planetNode = SCNNode()
        planetNode.geometry = ball
        planetNode.position = SCNVector3(x:0, y:0, z:0)
        
        planetNode.geometry?.firstMaterial?.ambient.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/ambient.png")
        planetNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/map.png")
        
        planetNode.geometry?.firstMaterial?.normal.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/normal.png")
        planetNode.geometry?.firstMaterial?.normal.intensity = 0.6
        
        planetNode.geometry?.firstMaterial?.specular.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/specular.png")
        planetNode.geometry?.firstMaterial?.specular.intensity = 0.1
        
        planetNode.geometry?.firstMaterial?.emission.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/emission.jpg")
        
        let action = SCNAction.rotate(by:720 * CGFloat((.pi)/100.0), around: SCNVector3(x:0, y:1, z:0), duration:60)
        let repeatAction = SCNAction.repeatForever(action)
        
        scnScene.rootNode.addChildNode(planetNode)
        planetNode.runAction(repeatAction)
    }

    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        // if menu is NOT visible, open it
        if !menuVisible {
            openMenu()
        }
        // if menu IS visible, close it
        else {
            closeMenu()
        }
    }
    
    func openMenu(){
        leading.constant = 150
        trailing.constant = -150
        menuVisible = true
        // should pause the scene view while menu is open
        animateViewSlide()
    }
    
    func closeMenu(){
        leading.constant = 0
        trailing.constant = 0
        menuVisible = false
        
        animateViewSlide()
    }
    
    func animateViewSlide(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func planetChooser(_ sender: UIButton) {
        planet = sender.currentTitle!
        planetNode.removeFromParentNode()
        sunNode.removeFromParentNode()
        closeMenu()
        
        spawnPlanet(planet: planet)
        setLabels(planet: planet)
        //setupSun()
        omni.intensity = CGFloat(omniIntensity)

    }
    
    func setLabels(planet: String){
        planetName.text = planet
        planetStats.text = loadPlanetStats(planet: planet)
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
                let sunIndex = str.index(str.startIndex, offsetBy: 4)
                let returnIndex = str.index(str.startIndex, offsetBy: 4)
                omniIntensity = Int(Double(str.substring(to: sunIndex))!)
                print("omni = \(omniIntensity)")
                returnString = str.substring(from: returnIndex)
                //print(returnString)
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
