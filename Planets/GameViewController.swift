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
import CoreFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var planetName: UILabel!
    @IBOutlet weak var planetStats: UILabel!
    
    @IBOutlet var welcomeView: UIView!
    @IBOutlet weak var gettingStartedButton: UIButton!
    
    var scnScene: SCNScene!
    var cameraNode: SCNNode!

    var planetNode: SCNNode!
    var sunNode: SCNNode!
    var omni: SCNLight!
    var sunLighting1: SCNNode!
    var sunLighting2: SCNNode!
    var sunLighting3: SCNNode!

    var omniIntensity = 1400
    
    var planet = "Earth"
    var menuVisible = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        UIView.animate(withDuration: 5.0, animations: {
            self.view.alpha = 1.0
        })
        
        setupView()
        setupScene()
        setupCamera()
        setupLight()
        
        spawnPlanet(planet: planet)
        setLabels(planet: planet)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if (!launchedBefore) {
            // show the welcome view
            welcomeView.frame = CGRect(x: 0, y: 0, width: (parent?.view.frame.width)!, height: (parent?.view.frame.height)!)
            self.view.addSubview(welcomeView)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    @IBAction func getStartedButtonClick(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, animations: {
            self.welcomeView.alpha = 0
        }, completion: {(finished:Bool) in
            self.welcomeView.removeFromSuperview()
        })
    }
    
    
    func openMenu(){
        leading.constant = 150
        trailing.constant = -150
        menuVisible = true
        // should pause the scene view while menu is open
        scnScene.isPaused = true
        animateViewSlide()
    }
    
    func closeMenu(){
        leading.constant = 0
        trailing.constant = 0
        menuVisible = false
        scnScene.isPaused = false
        animateViewSlide()
    }
    
    func animateViewSlide(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setupView() {
        scnView.showsStatistics = false
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
        omniNode.position = SCNVector3(x: 3, y: 3, z: 3)

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
        ambient.intensity = 200
        scnScene.rootNode.addChildNode(ambientNode)
        
        sunLighting1 = SCNNode()
        sunLighting2 = SCNNode()
        sunLighting3 = SCNNode()
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    

    func fade(from: Double, to: Double){
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = 1.5
        animation.isRemovedOnCompletion = true
        
        planetNode.addAnimation(animation, forKey: "opacity")
        
    }
    
    func spawnPlanet(planet: String) {
        planetNode = SCNNode()
        
        planetNode.geometry = SCNSphere(radius: 1.0)
        planetNode.position = SCNVector3(x:0, y:0, z:0)
        
        planetNode.geometry?.firstMaterial?.ambient.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/ambient.png")
        planetNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/map.png")
        //planetNode.geometry?.firstMaterial?.transparent.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/clouds.png")
        planetNode.geometry?.firstMaterial?.normal.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/normal.png")
        planetNode.geometry?.firstMaterial?.normal.intensity = 0.6
        
        planetNode.geometry?.firstMaterial?.specular.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/specular.png")
        planetNode.geometry?.firstMaterial?.specular.intensity = 0.1
        
        planetNode.geometry?.firstMaterial?.emission.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/emission.png")
        
        if(planet == "Saturn"){
            let ringNode = SCNNode()
            ringNode.geometry = SCNTorus(ringRadius: 1.8, pipeRadius: 0.5)
            ringNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "objects.scnassets/Textures/" + planet + "/ring.png")
            ringNode.scale = SCNVector3(x: 1, y: 0.05, z: 0.7)
            planetNode.addChildNode(ringNode)
        }
        
        let action = SCNAction.repeatForever(SCNAction.rotate(by:720 * CGFloat((.pi)/100.0), around: SCNVector3(x:0, y:1, z:0), duration:60))
        
        
        scnScene.rootNode.addChildNode(planetNode)
        fade(from:0.0, to:1.0) // fade in
        
        planetNode?.runAction(action)


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

    @IBAction func planetChooser(_ sender: UIButton) {
        
        if(planet == sender.currentTitle!){
            // do nothing
            closeMenu()
        } else {
        
        planet = sender.currentTitle!
        resetScene()

        spawnPlanet(planet: planet)
        setLabels(planet: planet)
        omni.intensity = CGFloat(omniIntensity)
        }
    }
    
    func resetScene(){
        fade(from:1.0, to:0.0) // fade out
        
        planetNode.removeFromParentNode()
        sunLighting1.removeFromParentNode()
        sunLighting2.removeFromParentNode()
        sunLighting3.removeFromParentNode()
        
        closeMenu()
        
        scnView.pointOfView?.position = SCNVector3(x: 0, y: 0, z: 5)
        scnView.pointOfView?.rotation = SCNVector4(x: 0, y: 0, z: 0, w:0)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        if menuVisible {
            closeMenu()
        }
    }
    
    @IBAction func aboutPressed(_ sender: UIButton) {
        closeMenu()
    }
    
    @IBAction func helpPressed(_ sender: UIButton) {
        closeMenu()
        UIView.animate(withDuration: 1, animations: {
            self.view.addSubview(self.welcomeView)
            self.welcomeView.alpha = 1
        })
    }
    
    
    func setLabels(planet: String){
        planetName.text = planet
        planetStats.text = loadPlanetStats(planet: planet)
        
        if(planet == "Sun"){
           setupSunLight()
            setupParticle()
        }
    }
    
    func loadPlanetStats(planet: String) -> String{
        var returnString = ""
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
    
    func setupSunLight(){
        sunLighting1.position = SCNVector3(x: -3, y: -3, z: -3) // left
        sunLighting2.position = SCNVector3(x: 3, y: -2, z:-3) // left

        sunLighting1.light = omni
        
        let ambient2 = SCNLight()
        sunLighting1.light = ambient2
        ambient2.type = SCNLight.LightType.ambient
        ambient2.intensity = 500
        
        sunLighting2.light = ambient2

        scnScene.rootNode.addChildNode(sunLighting1)
        scnScene.rootNode.addChildNode(sunLighting2)
    }
    
    
    func setupParticle(){
        let flame = SCNParticleSystem(named: "ParticleSystem.scnp", inDirectory: nil)!
        planetNode.addParticleSystem(flame)
    }
    
}

extension UIImage {
    func caLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        layer.contents = self.cgImage
        return layer
    }
}
