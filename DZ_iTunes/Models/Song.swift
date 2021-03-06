//
//  Song.swift
//  DZ_iTunes
//
//  Created by user on 27/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import Foundation

struct Song: Decodable {
    
    var artistName: String
    var trackName: String
    var previewUrl: URL
    var imageUrl: URL
    var trackPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case previewUrl
        case imageUrl = "artworkUrl100"
        case trackPrice
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try container.decode(String.self, forKey: CodingKeys.artistName)
        trackName = try container.decode(String.self, forKey: CodingKeys.trackName)
        previewUrl = try container.decode(URL.self, forKey: CodingKeys.previewUrl)
        imageUrl = try container.decode(URL.self, forKey: CodingKeys.imageUrl)
        trackPrice = try container.decode(Double.self, forKey: CodingKeys.trackPrice)
    }
    
}

extension Song {
    
    static func songPathURL(with artistName: String, trackName: String) -> URL {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        let documentsPathURL = URL(fileURLWithPath: documentsPath)
        
        var finalPath = documentsPathURL.appendingPathComponent("Preview")
        
        try? FileManager.default.createDirectory(at: finalPath, withIntermediateDirectories: true, attributes: nil)
        
        finalPath.appendPathComponent("\(artistName)-\(trackName).m4a")
        
        return finalPath
    }
    
}
