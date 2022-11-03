//
//  CameraView.swift
//  AVCamera
//
//  Created by MANAS VIJAYWARGIYA on 03/11/22.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIViewController
  
  let cameraService: CameraService
  let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
  
  func makeUIViewController(context: Context) -> UIViewController {
    
    cameraService.start(delegate: context.coordinator) { err in
      if let err {
        didFinishProcessingPhoto(.failure(err))
        return
      }
    }
    
    let viewController = UIViewController()
    viewController.view.backgroundColor = .black
    viewController.view.layer.addSublayer(cameraService.previewLayer)
    cameraService.previewLayer.frame = viewController.view.bounds
    return viewController
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self, didFinishProcessingPhoto: didFinishProcessingPhoto)
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
  
  
  class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
    let parent: CameraView
    private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    init(parent: CameraView, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ()) {
      self.parent = parent
      self.didFinishProcessingPhoto = didFinishProcessingPhoto
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
      if let error {
        didFinishProcessingPhoto(.failure(error))
        return
      }
      didFinishProcessingPhoto(.success(photo))
      parent.cameraService.session?.stopRunning()
    }
  }
}
