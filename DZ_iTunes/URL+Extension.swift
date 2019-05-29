//
//  URL+Extension.swift
//  DZ_iTunes
//
//  Created by user on 27/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import Foundation

extension URL {
    
    static func songPathURL(with artistName: String, trackName: String) -> URL {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        let documentsPathURL = URL(fileURLWithPath: documentsPath)
        
        var finalPath = documentsPathURL.appendingPathComponent("Preview")
        
        try? FileManager.default.createDirectory(at: finalPath, withIntermediateDirectories: true, attributes: nil)
        
        finalPath.appendPathComponent("\(artistName)-\(trackName).m4a")
        
        return finalPath
    }
    
    func urlWithQueryItems(for params: [String: String]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        let queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems = queryItems
        return components.url
    }
    
}
