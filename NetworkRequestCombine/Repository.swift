//
//  Repository.swift
//  NetworkRequestCombine
//
//  Created by Noye Samuel on 10/05/2023.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func getUsers() -> AnyPublisher<[User], Error>
    func getPost(userId: Int) -> AnyPublisher<[Post], Error>
    func getComment(postId: Int) -> AnyPublisher<[Comment], Error>
}

class CombineImp {
    func getUsers() -> AnyPublisher<[User], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [User].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getPost(userId: Int) -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=\(userId)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [Post].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getComment(postId: Int) -> AnyPublisher<[Comment], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [Comment].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockImp : DataServiceProtocol {
    let testUsers: [User] = [User(id: 1, name: "Sam")]
    let testPosts: [Post] = [Post(id: 1, userId: 1, body: "String", title: "Twitier")]
    let testCommets: [Comment] = [Comment(id: 1, postId: 1, email: "gbjdj@hjfj.com")]
    
    func getUsers() -> AnyPublisher<[User], Error> {
        Just(testUsers)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
    
    func getPost(userId: Int) -> AnyPublisher<[Post], Error> {
        Just(testPosts)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
    
    func getComment(postId: Int) -> AnyPublisher<[Comment], Error> {
        Just(testCommets)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
    
}
