//
//  ServerManager.swift
//  DZ_iTunes
//
//  Created by user on 27/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import UIKit

final class ServerManager {
    
    static let manager = ServerManager()
    
    var imageCache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func fetchData(from url: URL, completion: @escaping ([Song]?, NSError?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                let error = NSError(domain: "Failed to get data", code: 111, userInfo: nil)
                completion(nil, error)
                return
            }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                completion(result.results, nil)
            } catch {
                let error = NSError(domain: "Failed to decode data", code: 112, userInfo: nil)
                completion(nil, error)
            }
        }.resume()
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            guard let imageData = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: imageData)
            completion(image)
        }
    }
    
}
