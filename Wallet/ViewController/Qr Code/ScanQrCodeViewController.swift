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
import TLPhotoPicker

protocol ScanQrCodeViewControllerDelegate: AnyObject {
    func didScanWalletSuccess(_ scanQrCodeViewController: ScanQrCodeViewController, chainId: String, userId: String, castcleId: String)
    func didScanTextSuccess(_ scanQrCodeViewController: ScanQrCodeViewController, text: String)
}

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
    @IBOutlet weak var galleryButton: UIButton!

    public var delegate: ScanQrCodeViewControllerDelegate?
    var viewModel = ScanQrCodeViewModel()
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
        self.copyButton.setImage(UIImage.init(icon: .castcle(.copy), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.galleryButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 30, height: 30), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)

        self.myQrButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.myQrButton.setIcon(prefixText: "", prefixTextColor: UIColor.Asset.white, icon: .castcle(.qrCode), iconColor: UIColor.Asset.white, postfixText: "  My QR Code", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 14)
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
        ApiHelper.displayMessage(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.")
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
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.handleByScanType(value: stringValue)
        }
    }

    private func handleByScanType(value: String) {
        if self.viewModel.scanType == .wallet {
            if self.viewModel.isWalletData(value: value) && self.viewModel.isCorrectWalletData(value: value) {
                self.captureSession.stopRunning()
                Utility.currentViewController().navigationController?.popViewController(animated: true)
                self.delegate?.didScanWalletSuccess(self, chainId: self.viewModel.chainId, userId: self.viewModel.userId, castcleId: self.viewModel.castcleId)
            }
        } else if self.viewModel.scanType == .text {
            self.captureSession.stopRunning()
            Utility.currentViewController().navigationController?.popViewController(animated: true)
            self.delegate?.didScanTextSuccess(self, text: value)
        } else {
            self.captureSession.stopRunning()
            self.foundData(value: value)
        }
    }

    private func foundData(value: String) {
        if self.viewModel.isWalletData(value: value) {
            self.viewModel.validateQrCode(value: value)
        } else if value.isUrl, let url = URL(string: value) {
            self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(url)), animated: true)
            }
        } else {
            self.dataLabel.text = value
            self.dataView.isHidden = false
        }
    }

    private func selectCameraRoll() {
        let photosPickerViewController = TLPhotosPickerViewController()
        photosPickerViewController.delegate = self
        photosPickerViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.navigationBar.isTranslucent = false
        photosPickerViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)

        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.singleSelectedMode = true
        configure.mediaType = .image
        configure.usedCameraButton = false
        configure.allowedLivePhotos = false
        configure.allowedPhotograph = false
        configure.allowedVideo = false
        configure.autoPlay = false
        configure.allowedVideoRecording = false
        configure.selectedColor = UIColor.Asset.lightBlue
        photosPickerViewController.configure = configure
        Utility.currentViewController().present(photosPickerViewController, animated: true, completion: nil)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func myQrAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.castcleQrCode(.wallet)), animated: true)
        }
    }

    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = self.dataLabel.text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    @IBAction func galleryAction(_ sender: Any) {
        self.captureSession.stopRunning()
        self.selectCameraRoll()
    }
}

extension ScanQrCodeViewController: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first {
            if let image = asset.fullResolutionImage, let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]), let ciImage: CIImage = CIImage(image: image), let features = detector.features(in: ciImage) as? [CIQRCodeFeature] {
                var qrCodeString = ""
                features.forEach { feature in
                    if let messageString = feature.messageString {
                        qrCodeString += messageString
                    }
                }
                if qrCodeString.isEmpty {
                    self.failed()
                } else {
                    self.handleByScanType(value: qrCodeString)
                }
            } else {
                self.failed()
            }
        }
        return true
    }
}
