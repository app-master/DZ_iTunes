//
//  URL+Extension.swift
//  DZ_iTunes
//
//  Created by user on 27/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import Foundation

extension URL {
    
    func urlWithQueryItems(for params: [String: String]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        let queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems = queryItems
        return components.url
    }
    
}
