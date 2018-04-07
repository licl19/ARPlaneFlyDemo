//
//  ARSCNViewViewController.swift
//  ARPlaneFlyDemo
//
//  Created by lichanglai on 2018/4/7.
//  Copyright © 2018年 sankai. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

extension ARSCNViewViewController : ARSCNViewDelegate {
    
}
extension ARSCNViewViewController : ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print("\(#function) in \(#file)")
        if planeNode != nil {
            planeNode?.position = SCNVector3.init(frame.camera.transform.columns.3.x,frame.camera.transform.columns.3.y,frame.camera.transform.columns.3.z)
        }
    }
}

class ARSCNViewViewController: UIViewController {

    lazy var arSCNView: ARSCNView = {
        let scnViewTmp = ARSCNView(frame: view.bounds)
        scnViewTmp.delegate = self
        scnViewTmp.session = arSession
        scnViewTmp.automaticallyUpdatesLighting = true
        return scnViewTmp
    }()
    lazy var arSession: ARSession = {
        let sessionTmp = ARSession()
        sessionTmp.delegate = self
        return sessionTmp
    }()
    lazy var arSessionConfiguration: ARWorldTrackingConfiguration = {
        let sessionConfigurationTmp = ARWorldTrackingConfiguration()
        sessionConfigurationTmp.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
        sessionConfigurationTmp.isLightEstimationEnabled = true
        return sessionConfigurationTmp
    }()
    var planeNode : SCNNode?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(arSCNView)
        arSession.run(arSessionConfiguration, options: ARSession.RunOptions.removeExistingAnchors)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        planeNode?.removeFromParentNode()
        
        let scene = SCNScene.init(named: "Models.scnassets/lamp/lamp.scn")
        let shipNode = scene?.rootNode.childNodes[0]
        planeNode = shipNode
        shipNode?.scale = SCNVector3.init(0.5, 0.5, 0.5)
        shipNode?.position = SCNVector3.init(0, -15, -15)
        for node : SCNNode in (shipNode?.childNodes)! {
            node.scale = SCNVector3.init(0.5, 0.5, 0.5)
            node.position = SCNVector3.init(0, -15, -15)
        }
        planeNode?.position = SCNVector3.init(0, 0, -20)
        
        let placeNode = SCNNode()
        placeNode.position = arSCNView.scene.rootNode.position
        arSCNView.scene.rootNode.addChildNode(placeNode)
        
        placeNode.addChildNode(planeNode!)
        
        let moonRotationAnimation = CABasicAnimation.init(keyPath: "rotation")
        moonRotationAnimation.duration = 30
        moonRotationAnimation.toValue = NSValue.init(scnVector4: SCNVector4.init(0, 1, 0, M_PI * 2))
        moonRotationAnimation.repeatCount = FLT_MAX
        placeNode.addAnimation(moonRotationAnimation, forKey: "moonRotationAnimation")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
