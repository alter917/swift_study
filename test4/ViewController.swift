//
//  ViewController.swift
//  test4
//
//  Created by hideyuki matsuura on 2017/12/24.
//  Copyright © 2017年 hideyuki matsuura. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    var session = AVCaptureSession()
    var photoOutputObj = AVCapturePhotoOutput()
    let notification = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if session.isRunning {
            return
        }
        
        setUpInputOutput()
        setPreviewLayer()
        session.startRunning()
        notification.addObserver(self, selector: #selector(self.chnagedDeviceOrientation(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let captureSetting = AVCapturePhotoSettings()
        captureSetting.flashMode = .auto
        captureSetting.isAutoStillImageStabilizationEnabled = true
        captureSetting.isHighResolutionPhotoEnabled = false
        photoOutputObj.capturePhoto(with: captureSetting, delegate: self)
    }
    
    func setUpInputOutput() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            let device = AVCaptureDevice.default(
                AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                for: AVMediaType.video,
                position: AVCaptureDevice.Position.back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("セッションに入力を追加できなかった")
                return
            }
        } catch let error as NSError {
            print("カメラがない\(error)")
            return
        }
        
        if session.canAddOutput(photoOutputObj) {
            session.addOutput(photoOutputObj)
        } else {
            print("セッションに出力を追加できなかった")
        }
    }
    
    func setPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.masksToBounds = true
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        previewView.layer.addSublayer(previewLayer)
    }
    
    @objc func chnagedDeviceOrientation(_ notification: Notification) {
        if let photoOutputconnection = self.photoOutputObj.connection(with: AVMediaType.video) {
            switch UIDevice.current.orientation {
            case .portrait:
                photoOutputconnection.videoOrientation = .portrait
            case .portraitUpsideDown:
                photoOutputconnection.videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                photoOutputconnection.videoOrientation = .landscapeRight
            case .landscapeRight:
                photoOutputconnection.videoOrientation = .landscapeLeft
            default:
                break
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

