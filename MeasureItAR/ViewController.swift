//
//  ViewController.swift
//  MeasureItAR
//
//  Created by Veldanov, Anton on 4/20/20.
//  Copyright © 2020 Anton Veldanov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
  
  var dotNodes = [SCNNode]()
  var textNode = SCNNode()
  
  
  @IBOutlet var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the view's delegate
    sceneView.delegate = self
    
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    
//    sceneView.autoenablesDefaultLighting =  true

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    
    // Run the view's session
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
  }
  
  
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if dotNodes.count >= 2{
      for dot in dotNodes{
        dot.removeFromParentNode()
      }
      dotNodes = [SCNNode]()
      
    }
    
    
    if let touchLocation = touches.first?.location(in: sceneView){
      let hitTestResult = sceneView.hitTest(touchLocation, types: .featurePoint)
      if let hitResult = hitTestResult.first{
        
        addDot(at: hitResult)
        
      }
      
      
    }
    
    
  }
  
  func addDot(at hitResult : ARHitTestResult){
    
    let dotGeometry = SCNSphere(radius: 0.01)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.red
    dotGeometry.materials = [material]
    
    let dotNode = SCNNode(geometry: dotGeometry)

    
    dotNode.position = SCNVector3(
      hitResult.worldTransform.columns.3.x,
      hitResult.worldTransform.columns.3.y,
      hitResult.worldTransform.columns.3.z)
    
    sceneView.scene.rootNode.addChildNode(dotNode)
    
    
    dotNodes.append(dotNode)
    
    if dotNodes.count >= 2{
      
      calculate()
      
    }
    
    
    
  }
  
  func calculate(){
    
    let start = dotNodes[0] // first node put on the screen
    let end = dotNodes[1]
    
    // distances
    let a = end.position.x - start.position.x
    let b = end.position.y - start.position.y
    let c = end.position.z - start.position.z
    
    let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
//    print(abs(distance))
    
    updateText(text: "\(distance)", atPosition: end.position)
  }
  
  func updateText(text: String, atPosition position: SCNVector3){
    
    textNode.removeFromParentNode()
    
    let textGeomentry = SCNText(string: text, extrusionDepth: 1.0)
    textGeomentry.firstMaterial?.diffuse.contents = UIColor.systemPink
    
    textNode = SCNNode(geometry: textGeomentry)
    
    
    textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
    
    textNode.scale = SCNVector3(0.01, 0.01, 0.01)
    
    sceneView.scene.rootNode.addChildNode(textNode)
    
  }
  
  
}
