//
//  MiAlbum.swift
//  Imagenes
//
//  Created by Jan Zelaznog on 21/05/22.
//

import Photos
import UIKit

class MiAlbum : NSObject {
    
    static let instance = MiAlbum()
    override private init() {
        super.init()
    }
    
    static let albumName = "FotosDeMiApp"
    
    func guardar(_ imagen:UIImage) {
        func saveIt(_ validAssets: PHAssetCollection){
            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: imagen)
                let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: validAssets)
                let enumeration: NSArray = [assetPlaceHolder!]
                albumChangeRequest!.addAssets(enumeration)
            }, completionHandler: nil)
        }
        self.checarPermisos { (success) in
            if success {
                if let validAssets = self.assetCollection() { // Album already exists
                    saveIt(validAssets)
                }
                else {                                    // create an asset collection with the album name
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: MiAlbum.albumName)
                    })
                    { success, error in
                        if success, let validAssets = self.assetCollection() {
                            saveIt(validAssets)
                        }
                        else {
                            print ("Sorry, unable to create album and save image...")
                        }
                    }
                }
            }
        }
    }
    // se usa un closure cuando necesitamos saber el resultado de una función pero esta se ejecuta asincrona
    func checarPermisos( completion: @escaping ((_ success:Bool) -> Void) ) {
        let permisos = PHPhotoLibrary.authorizationStatus()
        if permisos == .authorized {
            completion (true)
        }
        else if permisos == .denied {
            completion (false)
        }
        else {
            PHPhotoLibrary.requestAuthorization() { status in
                self.checarPermisos(completion: completion)
            }
        }
    }
    
    private func assetCollection() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", MiAlbum.albumName)
        let fetch = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return fetch.firstObject
    }
}
