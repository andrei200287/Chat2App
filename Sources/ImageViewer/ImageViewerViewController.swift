//
//  ImageViewerViewController.swift
//  
//
//  Created by Andrei Solovjev on 27/10/2022.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    var image: UIImage?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView(){
        self.view.backgroundColor = .AppBackgroundColor
        self.scrollView.delegate = self
        self.imageView.image = image
        self.closeButton.setTitle("Close", for: .normal)
    }

    @IBAction func onCloseTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension ImageViewerViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
