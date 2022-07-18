//
//  QRCodeScannerView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 27.05.2022..
//

import SwiftUI
import UIKit
import AVFoundation

final class ScanView: NSObject, UIViewRepresentable, AVCaptureMetadataOutputObjectsDelegate {
    
    let handler: CovidCertificatesViewModel
    let colorScheme: ColorScheme
    
    private let captureSession = AVCaptureSession()
    
    init(handler: CovidCertificatesViewModel, colorScheme: ColorScheme){
        self.handler = handler
        self.colorScheme = colorScheme
    }
    
    func makeUIView(context: UIViewRepresentableContext<ScanView>) -> CameraPreview {
        let baseView = CameraPreview(handler: handler)
        checkCameraAuthorizationStatus(baseView)
        return baseView
    }
    
    private func checkCameraAuthorizationStatus(_ uiView: CameraPreview) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized {
            #if targetEnvironment(simulator)
                uiView.createSimulatorView(colorScheme: colorScheme)
            #else
                setupCamera(uiView)
            #endif
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else {return}
                DispatchQueue.main.sync {
                    if granted {
                        #if targetEnvironment(simulator)
                            uiView.createSimulatorView(colorScheme: self.colorScheme)
                        #else
                            self.setupCamera(uiView)
                        #endif
                    } else {
                        uiView.createCameraDeniedView(colorScheme: self.colorScheme)
                    }
                }
            }
        }
    }
    
    func setupCamera(_ uiView: CameraPreview){
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video),
           let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) {
            
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(captureMetadataOutput){
                captureSession.addOutput(captureMetadataOutput)
                captureMetadataOutput.metadataObjectTypes = [.qr]
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
            
            setupPreviewLayer(uiView: uiView)
        }
    }
    
    private func setupPreviewLayer(uiView: CameraPreview){
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        uiView.layer.addSublayer(previewLayer)
        uiView.layer.shadowPath = UIBezierPath(rect: uiView.bounds).cgPath
        uiView.previewLayer = previewLayer
    }
    
    func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<ScanView>) {
        if handler.isRescan {
            captureSession.stopRunning()
        } else {
            setupCamera(uiView)
            captureSession.startRunning()
        }
    }
}

extension ScanView {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            handler.handleScannedValue(stringValue) 
        }
    }
}
