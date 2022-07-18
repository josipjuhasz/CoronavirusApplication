//
//  CameraPreview.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 27.05.2022..
//

import UIKit
import AVFoundation
import SwiftUI

class CameraPreview: UIView, UIGestureRecognizerDelegate {
    
    var handler: CovidCertificatesViewModel
    
    private var label:UILabel?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(handler: CovidCertificatesViewModel) {
        self.handler = handler
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSimulatorView(colorScheme: ColorScheme){
        label = UILabel(frame: self.bounds)
        label?.backgroundColor = colorScheme == .light ? UIColor.white : UIColor.black
        label?.numberOfLines = 4
        label?.text = "Click here to simulate scan"
        label?.textColor = colorScheme == .light ? UIColor.black : UIColor.white
        label?.textAlignment = .center
        if let label = label {
            addSubview(label)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentMockData))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func presentMockData(){
        let token = "HC1:6BFOXN%TSMAHN-HISCCPV4DU30PMXK/R89PPNDC2LE%$CAJ9AIVG8QB/I:VPI7ONO4*J8/Y4IGF5JNBPINXUQXJ $U H9IRIBPI$RU2G0BI6QJAWVH/UI2YU-H6/V7Y0W*VBCZ79XQLWJM27F75R540T9S/FP1JXGGXHGTGK%12N:IN1MPK9PYL+Q6JWE 0R746QW6T3R/Q6ZC6:66746+O615F631$02VB1%96$01W.M.NEQ7VU+U-RUV*6SR6H 1PK9//0OK5UX4795Y%KBAD5II+:LQ12J%44$2%35Y.IE.KD+2H0D3ZCU7JI$2K3JQH5-Y3$PA$HSCHBI I799.Q5*PP:+P*.1D9R+Q0$*OWGOKEQEC5L64HX6IAS3DS2980IQODPUHLO$GAHLW 70SO:GOLIROGO3T59YLLYP-HQLTQ9R0+L6G%5TW5A 6YO67N6N7E931U9N%QLXVT*VHHP7VRDSIEAP5M9N0SB9BODZV0JEY9KQ7KEWP.T2E:7*CAC:C5Z873UF C+9OB.5TDU1PT %F6NATW6513TMG.:A+5AOPG"
        handler.handleScannedValue(token)
    }
    
    func createCameraDeniedView(colorScheme: ColorScheme){
        label = UILabel(frame: self.bounds)
        label?.backgroundColor = colorScheme == .light ? UIColor.white : UIColor.black
        label?.numberOfLines = 4
        label?.text = "Camera access denied! Go to Settings -> Privacy -> Camera and allow access."
        label?.textColor = colorScheme == .light ? UIColor.black : UIColor.white
        label?.textAlignment = .center
        if let label = label {
            addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            label?.frame = self.bounds
        #else
            previewLayer?.frame = self.bounds
        #endif
    }
}
