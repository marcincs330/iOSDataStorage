//
//  RealmRepository.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 22/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRepository: ContentRepository {
    lazy var contents: [Content] = {
        let realm = try! Realm()
        let contentsRealm = realm.objects(ContentRealm.self)
        return contentsRealm.map {
            Content(contentRealm: $0)
        }
    }()
    func save(contents: [Content]) {
        DispatchQueue(label: "Realm").async {
            print("*** Rozpoczęto zapisywanie ***")
            autoreleasepool {
                let realm = try! Realm()
                realm.beginWrite()
                for content in contents {
                    let contentObj = ContentRealm()
                    contentObj.kind = content.kind
                    contentObj.trackName = content.trackName
                    contentObj.artistName = content.artistName
                    contentObj.collectionName = content.collectionName
                    if let image = content.artworkImage {
                        contentObj.artworkImage = UIImagePNGRepresentation(image) as NSData?
                    } else {
                        contentObj.artworkImage = nil
                    }
                    contentObj.country = content.country
                    contentObj.primaryGenreName = content.primaryGenreName
                    contentObj.date = content.date
                    realm.add(contentObj)
                }
                try! realm.commitWrite()
                
            }
        }
        
    }
}