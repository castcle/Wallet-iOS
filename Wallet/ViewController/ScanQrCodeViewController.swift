//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  ScanQrCodeViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 27/5/2565 BE.
//

import UIKit
import AVFoundation
import Core
import Component
import Defaults

class ScanQrCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myQrButton: UIButton!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var dataView: UIView!

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.detailTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.detailTitleLabel.textColor = UIColor.Asset.white
        self.dataLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.dataLabel.textColor = UIColor.Asset.white
        self.backButton.setImage(UIImage.init(icon: .castcle(.back), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.copyButton.setImage(UIImage.init(icon: .castcle(.coin), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)

        self.myQrButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.myQrButton.setIcon(prefixText: "", prefixTextColor: UIColor.Asset.white, icon: .castcle(.airdropBox), iconColor: UIColor.Asset.white, postfixText: "  My QR Code", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 14)
        self.myQrButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.dataView.custom(color: UIColor.Asset.darkGray, cornerRadius: 5)
        self.dataView.isHidden = true
        self.detailView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupScanCamera()
    }

    private func setupScanCamera() {
        self.captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if self.captureSession.canAddInput(videoInput) {
            self.captureSession.addInput(videoInput)
        } else {
            self.failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            self.failed()
            return
        }
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.scanView.layer.addSublayer(self.previewLayer)
        self.captureSession.startRunning()
    }

    func failed() {
        let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        self.captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        Defaults[.screenId] = ""
        if !(self.captureSession?.isRunning ?? false) {
            self.captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if self.captureSession?.isRunning ?? false {
            self.captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.foundData(code: stringValue)
        }
    }

    private func foundData(code: String) {
        if code.isUrl, let url = URL(string: code) {
            self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(url)), animated: true)
            }
        } else {
            self.dataLabel.text = code
            self.dataView.isHidden = false
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func myQrAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.myQrCode), animated: true)
        }
    }

    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = self.dataLabel.text
    }
}
