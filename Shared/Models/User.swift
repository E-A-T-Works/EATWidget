//
//  User.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/10/22.
//

import Foundation


struct User: Hashable {
    let username: String
}


extension User: Decodable {}
