//
//  ViewModel.swift
//  NetworkRequestCombine
//
//  Created by Noye Samuel on 10/05/2023.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var comments : [Comment] = []
    @Published var posts : [Post] = []
    @Published var users : [User] = []
    
    var cancellables = Set<AnyCancellable>()
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        self.getComments()
        self.getUsers()
        self.gePosts()
    }
    
    func getUsers(){
        dataService.getUsers()
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedUsers in
                self?.users = returnedUsers
            }.store(in: &cancellables)
        
        print(users)
    }
    
    func getComments(){
        dataService.getComment(postId: 2)
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedComments in
                self?.comments = returnedComments
            }.store(in: &cancellables)
        
        print(comments)
    }
    
    func gePosts(){
        dataService.getPost(userId: 2)
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedPosts in
                self?.posts = returnedPosts
            }.store(in: &cancellables)
        
        print(posts)
    }
}
