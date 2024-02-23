//
//  ImageManager.swift
//
//
//  Created by Krati Mittal on 23/02/24.
//

import Foundation
import UIKit

class ImageManager {
    
    static var shared = ImageManager()
    
    private init() {}
    
    func getImageWithName(_ image: String) -> UIImage? {
        let fileExtension = "jpg"
        if let imageName = image.components(separatedBy: ".").first,
           let url = Bundle.main.url(forResource: imageName,
                                     withExtension: fileExtension),
           let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
}
