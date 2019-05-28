//
//  Result.swift
//  DZ_iTunes
//
//  Created by user on 27/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import Foundation

struct Result: Decodable {
    let resultCount: Int
    let results: [Song]
}
