//
//  ProfileViewController+Delegate.swift
//  ManUNews
//
//  Created by MILIKET on 3/9/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions
import SwiftyUserDefaults
import MXParallaxHeader

// MARK: - Parallax header delegate
extension ProfileViewController: MXParallaxHeaderDelegate {
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        
    }
}

//-------------------------------------------
//MARK:    - TABLE DATASOURCE
//-------------------------------------------
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFieldArray.count
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextFieldTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
        
    }
    
    func configureCell(_ cell: TextFieldTableViewCell, indexPath: IndexPath) {
        
        cell.selectionStyle = .none
        // Setup ImageView
        cell.imageView?.image = textFieldArray[(indexPath as NSIndexPath).row].image.tint(UIColor.gray)
        cell.seperatorStyle = .padding(15)
        cell.seperatorRightPadding = 15
        // Setup Text Field
        
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        cell.textField.placeholder = textFieldArray[(indexPath as NSIndexPath).row].placeHolder
        cell.textField.keyboardType = UIKeyboardType.default
        cell.textField.isEnabled = false
        switch (indexPath as NSIndexPath).row {
            
        case TextField.phone..:
            cell.textField.keyboardType = UIKeyboardType.phonePad
            cell.textField.text = ""
            textFieldPhone = cell.textField
            
        case TextField.name..:
            cell.textField.returnKeyType = UIReturnKeyType.next
            cell.textField.isEnabled = isEditingProfile
            cell.textField.text = ""
            
            textFieldName = cell.textField
            
        case TextField.email..:
            cell.textField.returnKeyType = UIReturnKeyType.done
            cell.textField.keyboardType = UIKeyboardType.emailAddress
            cell.textField.text = ""
            textFieldEmail = cell.textField
            
        default:
            break
        }
    }
}


//-------------------------------------------
//MARK:    - TABLE DELEGATE
//-------------------------------------------
extension ProfileViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        hideKeyboard()
    }
    
    
    
}

//-------------------------------------------
//MARK:    - TEXT FIELD DELEGATE
//-------------------------------------------
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldName {
            textFieldPhone.becomeFirstResponder()
        } else {
            textFieldEmail.resignFirstResponder()
        }
        return false
    }
}

//-------------------------------------------
//  MARK: - ACTION SHEET DELEGATE
//-------------------------------------------

extension ProfileViewController: UIActionSheetDelegate, UINavigationControllerDelegate {
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        switch buttonIndex {
        case 0: // Chọn bỏ qua
            return
            
        case 1: // Chọn thư viện
            picker.sourceType = .photoLibrary
            
        case 2: // Chọn Camera
            picker.sourceType = .camera
            
        default:
            break
        }
        present(picker, animated: true, completion: nil)
    }
}

//-------------------------------------------
//  MARK: - IMAGE PICKER DELEGATE
//-------------------------------------------

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        dismiss(animated: false, completion: nil)
        let croppedImage = cropImage(image, toSize:CGSize(width: 1024, height: 1024))
        
        selectedImage = croppedImage
        
        headerView.avatarImage.image = croppedImage
        headerView.avatarImage.alpha = 0.0
        headerView.avatarImage.contentMode = .scaleAspectFill
        UIView.animate(withDuration: 0.5.second, animations: {
            self.headerView.avatarImage.alpha = 1.0
        })
        
    }
    
    fileprivate func cropImage(_ image: UIImage, toSize size: CGSize) -> UIImage {
        
        var newSize: CGSize
        /**
         *  Resize xuống 1024 x 1024
         */
        if image.size.width >= image.size.height { newSize = CGSize(width: 1024, height: 1024 * image.size.height / image.size.width) }
        else { newSize = CGSize(width: 1024 * image.size.width / image.size.height, height: 1024) }
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        /**
         *  Crop to size
         */
        
        let x = ((newImage?.cgImage?.width)! - Int(size.width)) / 2
        let y = ((newImage?.cgImage?.height)! - Int(size.height)) / 2
        let cropRect = CGRect(x: x, y: y, width: Int(size.height), height: Int(size.width))
        let imageRef = newImage?.cgImage?.cropping(to: cropRect)
        
        let cropped = UIImage(cgImage: imageRef!, scale: 0.0, orientation: (newImage?.imageOrientation)!)
        return cropped
    }
}
