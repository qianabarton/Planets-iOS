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

class TestController: UIViewController {
    
    var sceneView: SCNView!
    var camera: SCNNode!
    var ground: SCNNode!
    var light: SCNNode!
    var button: SCNNode!
    var sphere1: SCNNode!
    var sphere2: SCNNode!
    
        var geometryNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        sceneView = SCNView(frame: self.view.frame)
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
        sceneView.allowsCameraControl = true
        
        

        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.blue
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)
        
        let camera = SCNCamera()
        camera.zFar = 10000
        self.camera = SCNNode()
        self.camera.camera = camera
        self.camera.position = SCNVector3(x: 0, y: 15, z: 15)
        let constraint = SCNLookAtConstraint(target: ground)
        constraint.isGimbalLockEnabled = true
        self.camera.constraints = [constraint]
        
        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGray
        ambientLight.type = SCNLight.LightType.ambient
        self.camera.light = ambientLight
        
        
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.castsShadow = true
        spotLight.spotInnerAngle = 70.0
        spotLight.spotOuterAngle = 90.0
        spotLight.zFar = 500
        light = SCNNode()
        light.light = spotLight
        light.position = SCNVector3(x: 0, y: 15, z: 15)
        light.constraints = [constraint]
        
        //test1()
        test2()
        

    }
    
    func test1(){
        
        let ball = SCNSphere(radius: 1.0)
        geometryNode = SCNNode()
        geometryNode.geometry = ball
        geometryNode.position = SCNVector3(x:0, y:2, z:0)
        
        geometryNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "objects.scnassets/Textures/venus_map_2.jpg")
        geometryNode.geometry?.firstMaterial?.specular.contents = UIImage(named: "objects.scnassets/Textures/venus_5.png")
        geometryNode.geometry?.firstMaterial?.specular.intensity = 0.8
        //geometryNode.geometry?.firstMaterial?.emission.contents = UIImage(named: "objects.scnassets/Textures/venus_emission.jpg")
        geometryNode.geometry?.firstMaterial?.normal.contents = UIImage(named: "objects.scnassets/Textures/venus_normal.jpg")
        //node.geometry?.firstMaterial?.multiply.contents = UIColor.orange
        
        let action = SCNAction.rotate(by:90 * CGFloat((.pi)/100.0), around: SCNVector3(x:0, y:1, z:0), duration:20)
        
        sceneView.scene?.rootNode.addChildNode(geometryNode)
        geometryNode.runAction(action)
    }
        
    func test2(){
        
        let action = SCNAction.rotate(by:360 * CGFloat((.pi)/100.0), around: SCNVector3(x:0, y:1, z:0), duration:50)
        
        let buttonGeometry = SCNBox(width: 4, height: 4, length: 4, chamferRadius: 0)
        let buttonMaterial = SCNMaterial()
        buttonMaterial.diffuse.contents = UIColor.red
        buttonGeometry.materials = [buttonMaterial]
        button = SCNNode(geometry: buttonGeometry)
        button.position = SCNVector3(x: 0, y: 3, z: 0)
        
        sceneView.scene?.rootNode.addChildNode(self.camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
        sceneView.scene?.rootNode.addChildNode(button)

        button.runAction(action)
        
    }
    
    
    
}

