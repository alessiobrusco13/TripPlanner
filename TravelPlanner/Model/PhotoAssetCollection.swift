//
//  PhotoAssetCollection.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos

class PhotoAssetCollection: RandomAccessCollection, IteratorProtocol, Sequence {
    private(set) var fetchResult: PHFetchResult<PHAsset>
    private var iteratorIndex = 0
    
    private var cache = [Int: PhotoAsset]()
    
    var startIndex: Int { 0 }
    var endIndex: Int { fetchResult.count }
    
    init(_ fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }

    subscript(position: Int) -> PhotoAsset {
        if let asset = cache[position] {
            return asset
        }
        
        let phAsset = fetchResult.object(at: position)
        let asset = PhotoAsset(phAsset: phAsset, index: position)
        
        cache[position] = asset
        return asset
    }
    
    var phAssets: [PHAsset] {
        var assets = [PHAsset]()
        
        fetchResult.enumerateObjects { object, _, _ in
            assets.append(object)
        }
        
        return assets
    }
    
    func next() -> PhotoAsset? {
        if iteratorIndex >= count {
            return nil
        }
        
        defer {
            iteratorIndex += 1
        }
        
        return self[iteratorIndex]
    }
}
