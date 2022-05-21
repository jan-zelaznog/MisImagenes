//
//  ViewController.swift
//  Imagenes
//
//  Created by Jan Zelaznog on 21/05/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var ivFoto: UIImageView!
    
    @IBAction func buscarFoto(_ sender: UIButton) {
        // variable local
        let ipc = UIImagePickerController()
        /* para trabajar con la galería
        ipc.sourceType = .photoLibrary
        */
        ipc.delegate = self
        // permitir edición
        ipc.allowsEditing = true
        // consultamos si la cámara esta disponible
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Se requiere la llave Privacy - Camer Usage Description en el archivo info.plist
            ipc.sourceType = .camera
            // Validar permiso de uso de la cámara
            let permisos = AVCaptureDevice.authorizationStatus(for: .video)
            if permisos == .authorized {
                self.present(ipc, animated: true,  completion: nil)
            }
            else {
                if permisos == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { respuesta in
                        if respuesta {
                            self.present(ipc, animated: true,  completion: nil)
                        }
                        else {
                            // cerrar la app?
                            // mostrar alert?
                            print ("no se que hacer  :(")
                        }
                    }
                }
                else {  // .denied
                    let alert = UIAlertController(title: "Error", message: "Debe autorizar el uso de la cámara desde el app de configuración. Quieres hacerlo ahora?", preferredStyle:.alert)
                    let btnSI = UIAlertAction(title: "Si, por favor", style: .default) { action in
                        // lanzar el app de settings:
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alert.addAction(btnSI)
                    alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else {
            ipc.sourceType = .photoLibrary
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print ("seleccionó")
        if let imagen = info[.editedImage] as? UIImage {
            ivFoto.image = imagen
            if picker.sourceType == .camera {
                // para guardar la foto a la galería
                // Se requiere la llave Privacy - Photo Library Usage Description en el archivo info.plist
                // UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
                // guardar la foto a el album personalizado del App
                MiAlbum.instance.guardar(imagen)
            }
        }
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("canceló")
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

