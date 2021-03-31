//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Adrian Lesniak on 21/02/2021.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var serialNumberField: UITextField!
    
    @IBOutlet var valueField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var removeImageButton: UIButton!
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.backButtonTitle = ""
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        let image = imageStore.image(forKey: item.itemKey)
        imageView.image = image
        removeImageButton.isHidden = image == nil
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text ?? ""
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeDate" {
            
            let vc = segue.destination as! DateViewController
            vc.date = item.dateCreated
        }
    }
    
    @IBAction func onDateChanged(for segue: UIStoryboardSegue) {
        let sourceVC = segue.source as! DateViewController
        
        item.dateCreated = sourceVC.getSelectedDate()
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: "Where from?", preferredStyle: .actionSheet)
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { _ in
                
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
                
            })
            
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func imagePicker(for source: UIImagePickerController.SourceType) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    // MARK: Picker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        imageView.image = image
        removeImageButton.isHidden = false
        
        imageStore.setImage(image, forKey: item.itemKey)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRemoveImageButtonTapped(_ sender: Any) {
        
        imageView.image = nil
        imageStore.deleteImage(forKey: item.itemKey)
        removeImageButton.isHidden = true
    }
}
