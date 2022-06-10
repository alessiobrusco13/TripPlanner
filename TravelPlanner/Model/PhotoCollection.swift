//
//  PhotoCollection.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos

class PhotoCollection: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    enum PhotoCollectionError: LocalizedError {
        case missingAssetCollection
        case missingAlbumName
        case missingLocalIdentifier
        case unableToFindAlbum(String)
        case unableToLoadSmartAlbum(PHAssetCollectionSubtype)
        case addImageError(Error)
        case createAlbumError(Error)
        case removeAllError(Error)
    }
    
    @Published var photoAssets = PhotoAssetCollection(PHFetchResult<PHAsset>())
    
    var identifier: String? {
        assetCollection?.localIdentifier
    }
    
    var albumName: String?
    var smartAlbumType: PHAssetCollectionSubtype?
    let cache = CachedImageManager()
    
    private var assetCollection: PHAssetCollection?
    
    init(albumNamed albumName: String) {
        self.albumName = albumName
        super.init()
    }

    init?(albumWithIdentifier identifier: String) {
        guard let assetCollection = PhotoCollection.getAlbum(identifier: identifier) else {
            return nil
        }
        
        self.assetCollection = assetCollection
        super.init()
        
        Task {
            await refreshPhotoAssets()
        }
    }
    
    init(smartAlbum smartAlbumType: PHAssetCollectionSubtype) {
        self.smartAlbumType = smartAlbumType
        super.init()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func load() async throws {
        PHPhotoLibrary.shared().register(self)
        
        if let smartAlbumType = smartAlbumType {
            if let assetCollection = PhotoCollection.getSmartAlbum(subtype: smartAlbumType) {
                self.assetCollection = assetCollection
                await refreshPhotoAssets()
                return
            } else {
                throw PhotoCollectionError.unableToLoadSmartAlbum(smartAlbumType)
            }
        }
        
        guard let name = albumName, !name.isEmpty else {
            throw PhotoCollectionError.missingAlbumName
        }
        
        if let assetCollection = PhotoCollection.getAlbum(named: name) {
            self.assetCollection = assetCollection
            await refreshPhotoAssets()
            return
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
            
            await refreshPhotoAssets()
            
        } catch {
            throw PhotoCollectionError.addImageError(error)
        }
    }
    
    func removeAsset(_ asset: PhotoAsset) async throws {
        guard let assetCollection = self.assetCollection else {
            throw PhotoCollectionError.missingAssetCollection
        }
        
        do {
            try await PHPhotoLibrary.shared().performChanges {
                if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection) {
                    albumChangeRequest.removeAssets([asset as Any] as NSArray)
                }
            }
            
            await refreshPhotoAssets()
            
        } catch {
            throw PhotoCollectionError.removeAllError(error)
        }
    }
    
    func removeAll() async throws {
        guard let assetCollection = self.assetCollection else {
            throw PhotoCollectionError.missingAssetCollection
        }
        
        do {
            try await PHPhotoLibrary.shared().performChanges {
                if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection),
                    let assets = (PHAsset.fetchAssets(in: assetCollection, options: nil) as AnyObject?) as! PHFetchResult<AnyObject>? {
                    albumChangeRequest.removeAssets(assets)
                }
            }
            
            await refreshPhotoAssets()
            
        } catch {
            throw PhotoCollectionError.removeAllError(error)
        }
    }
    
    private func refreshPhotoAssets(_ fetchResult: PHFetchResult<PHAsset>? = nil) async {
        var newFetchResult = fetchResult

        if newFetchResult == nil {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            if let assetCollection = self.assetCollection,
               let fetchResult = (PHAsset.fetchAssets(in: assetCollection, options: fetchOptions) as AnyObject?) as? PHFetchResult<PHAsset>
            {
                newFetchResult = fetchResult
            }
        }
        
        if let newFetchResult = newFetchResult {
            await MainActor.run {
                photoAssets = PhotoAssetCollection(newFetchResult)
            }
        }
    }

    private static func getAlbum(identifier: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: fetchOptions)
        return collections.firstObject
    }
    
    private static func getAlbum(named name: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collections.firstObject
    }
    
    private static func getSmartAlbum(subtype: PHAssetCollectionSubtype) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtype, options: fetchOptions)
        return collections.firstObject
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task { @MainActor in
            guard let changes = changeInstance.changeDetails(for: self.photoAssets.fetchResult) else { return }
            await self.refreshPhotoAssets(changes.fetchResultAfterChanges)
        }
    }
}
