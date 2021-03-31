//
//  ImageStore.swift
//  LootLogger
//
//  Created by Adrian Lesniak on 26/02/2021.
//

import Foundation
import UIKit

class ImageStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let imagURL = imageURL(for: key)
        
        if let data = image.jpegData(compressionQuality: 0.5) {
            try? data.write(to: imagURL)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(for: key)
        
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(for: key)
        
        do {
            
            try FileManager.default.removeItem(at: url)
            
        } catch {
            print("Error removing image at \(url.path)")
        }
    }
    
    func imageURL(for key: String) -> URL {
        let docDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = docDirectories.first!
        
        return docDirectory.appendingPathComponent(key)
    }
}
