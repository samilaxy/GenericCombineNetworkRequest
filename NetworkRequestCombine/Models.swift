//
//  DTO's.swift
//  NetworkRequestCombine
//
//  Created by Noye Samuel on 10/05/2023.
//

import Foundation


struct User: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Post: Decodable,  Identifiable {
    let id: Int
    let userId: Int
    let body: String
    let title: String
}

struct Comment: Decodable, Identifiable {
    let id: Int
    let postId: Int
    let email: String
}
