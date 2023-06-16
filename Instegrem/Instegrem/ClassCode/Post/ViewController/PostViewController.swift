//
//  PostViewController.swift
//  Instegrem
//
//  Created by Bao Long on 02/06/2023.
//

import UIKit

class PostViewController: UIViewController {
    var pickerController: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        print("DEBUG: DENINIT PostViewController")
    }
    
    //MARK: - Configure UI
    func configUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Tạo bài viết mới"
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cameraButton = UIButton(type: .system)
        cameraButton.setTitle("Chụp ảnh", for: .normal)
        cameraButton.setTitleColor(.black, for: .normal)
        cameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cameraButton.setImage(UIImage(named: "ic-camera")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        let cameraRollButton = UIButton(type: .system)
        cameraRollButton.setTitle("Ảnh đã chụp", for: .normal)
        cameraRollButton.setTitleColor(.black, for: .normal)
        cameraRollButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cameraRollButton.setImage(UIImage(named: "ic-camera_black")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cameraRollButton.addTarget(self, action: #selector(cameraRollButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(cameraRollButton)
        cameraRollButton.translatesAutoresizingMaskIntoConstraints = false
        
        let libraryButton = UIButton(type: .system)
        libraryButton.setTitle("Thư viện ảnh", for: .normal)
        libraryButton.setTitleColor(.black, for: .normal)
        libraryButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        libraryButton.setImage(UIImage(named: "ic-library")?.withRenderingMode(.alwaysOriginal), for: .normal)
        libraryButton.addTarget(self, action: #selector(libraryButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(libraryButton)
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            
            cameraRollButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cameraRollButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraRollButton.widthAnchor.constraint(equalToConstant: 150),
            
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: cameraRollButton.topAnchor, constant: -32),
            cameraButton.widthAnchor.constraint(equalToConstant: 150),

            
            libraryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            libraryButton.topAnchor.constraint(equalTo: cameraRollButton.bottomAnchor, constant: 32),
            libraryButton.widthAnchor.constraint(equalToConstant: 150)

        ])
    }
    
    @objc func cameraButtonTapped(_ sender: UIButton) {
        takeImage(type: .camera)
    }
    
    @objc func cameraRollButtonTapped(_ sender: UIButton) {
        takeImage(type: .savedPhotosAlbum)
    }
    
    @objc func libraryButtonTapped(_ sender: UIButton) {
        takeImage(type: .photoLibrary)
    }
    
    func takeImage(type: UIImagePickerController.SourceType) {
        pickerController = UIImagePickerController()
        pickerController.sourceType = type
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.setEditing(true, animated: true)
        pickerController.mediaTypes = ["public.image"]
//            strongSelf.pickerController.modalPresentationStyle = .overFullScreen
        present(pickerController, animated: true)
    }

}


extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.pickerController(picker, didSelect: nil)
//    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
//        self.pickerController(picker, didSelect: image)
        picker.dismiss(animated: true) {
            let vc = PostStatusViewController()
            vc.postImage = image
            vc.ratio = image.size.width / image.size.height
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        avt = image
//        isChangeAvatar = true
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
