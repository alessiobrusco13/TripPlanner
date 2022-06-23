//
//  PhotoCollection.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos

class PhotoCollection {
    enum PhotoCollectionError: Error {
        case missingAssetCollection
        case unableToLoadSmartAlbum(PHAssetCollectionSubtype)
        case addImageError(Error)
    }
    
    var identifier: String? {
        assetCollection?.localIdentifier
    }
    
    var smartAlbumType: PHAssetCollectionSubtype?
    let cache = CachedImageManager()
    
    private var assetCollection: PHAssetCollection?
    
    init(smartAlbum smartAlbumType: PHAssetCollectionSubtype) {
        self.smartAlbumType = smartAlbumType
    }
    
    func load() async throws {
        if let smartAlbumType = smartAlbumType {
            if let assetCollection = PhotoCollection.getSmartAlbum(subtype: smartAlbumType) {
                self.assetCollection = assetCollection
                return
            } else {
                throw PhotoCollectionError.unableToLoadSmartAlbum(smartAlbumType)
            }
        }
    }
    
    func addImage(_ imageData: Data) async throws {
        guard let assetCollection = self.assetCollection else {
            throw PhotoCollectionError.missingAssetCollection
        }
        
        do {
            try await PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                
                if let assetPlaceholder = creationRequest.placeholderForCreatedAsset {
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                    
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection), assetCollection.canPerform(.addContent) {
                        let fastEnumeration = NSArray(array: [assetPlaceholder])
                        albumChangeRequest.addAssets(fastEnumeration)
                    }
                }
            }
        } catch {
            throw PhotoCollectionError.addImageError(error)
        }
    }
    
    private static func getSmartAlbum(subtype: PHAssetCollectionSubtype) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtype, options: fetchOptions)
        
        return collections.firstObject
    }
}
