//
//  ViewController.swift
//  CropDemo
//
//  Created by Subhash Kimani on 17/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    /// imgCropResult is used to display crop image result
    @IBOutlet weak var imgCropResult: UIImageView!
    
    /// viewDidLoad is life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

/// Method(s)
extension ViewController {
    
    /// openCropView is used to open normal Crop ViewController with rotation and ration option
    /// - Parameter image: UIImage type, pass original image for crop
    func openCropView(image: UIImage) {
        // create crop viewcontroller object
        let cropViewController = CropperViewController(originalImage: image, ratio: .ratio(width: 1.96, height: 2.75), minFaceSize: 1.22, maxFaceSize: 1.41)
        // set delegate
        cropViewController.delegate = self
        // present crop viewcontroller
        self.present(cropViewController, animated: true)
    }
    
    /// openCircleShapeCropView is used to open circle Crop ViewCotnroller
    /// - Parameter image: UIImage type, pass original image for crop
    func openCircleShapeCropView(image: UIImage) {
        // create crop viewcontroller object
        let cropViewController = CropperViewController(originalImage: image, isCircular: true)
        // set delegate
        cropViewController.delegate = self
        // present crop viewcontroller
        self.present(cropViewController, animated: true)
    }
}

/// IBAction(s)
extension ViewController {
    /// onCrop is used to open crop view action
    /// - Parameter sender: UIButton type
    @IBAction func onCrop(_ sender : UIButton) {
        // 0 - HCrop, 1 - VCrop
        let name = sender.tag == 0 ? "sample1.jpg" : "Photo_One.jpg"
        guard let image = UIImage(named: name) else { return }
        
        self.openCropView(image: image)
    }
    
    /// onCircleCrop is used to open circle crop view action
    /// - Parameter sender: UIButton type
    @IBAction func onCircleCrop(_ sender : Any) {
        let name = "ARImage.png"
        guard let image = UIImage(named: name) else { return }
        
        self.openCircleShapeCropView(image: image)
    }
}
