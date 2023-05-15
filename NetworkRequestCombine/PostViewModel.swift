    //
    //  PostViewModel.swift
    //  NetworkRequestCombine
    //
    //  Created by Noye Samuel on 11/05/2023.
    //

import Foundation
import Combine

class PostViewModel: ObservableObject {
    
    let manager = NetworkManager()
    @Published var posts : [Post] = []
    @Published var users : [User] = []
    @Published var presentAlert = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.getPosts()
        self.searchUsers(limit: 2)
    }
    
        // MARK: - Non-param request
    func getPosts(){
        manager.request(from: .posts, paramsData: nil)
            .sink { _ in
                
            }  receiveValue: { [weak self] (returnedPost: [Post])  in
                self?.posts = returnedPost
            }.store(in: &cancellables)
    }
    
        // MARK: - A get request with a query param.
    func searchUsers(limit: Int) {
        
        let params: Params = [ "limit": limit ]
        manager.request(from: .users, paramsData: params)
            .sink(receiveCompletion: { completion in
                    // Handle completion or error if needed
            }, receiveValue: { [weak self] (users: [User]) in
                    // Handle the received users
                self?.users = users
            })
            .store(in: &cancellables)
    }
    
    
        // MARK: - A post request passing JSON data to the body.
    func createPost(title: String, body: String){
            // set the data to params format
        let params: Params = [ApiKeys.TITLE: title , ApiKeys.BODY: body, ApiKeys.USERID: 1, ApiKeys.ID: 101]
        
        manager.request(from: .create, paramsData: params)
            .sink ( receiveCompletion: { completion in
                switch(completion){
                    case .finished:
                        print("Post created successfully!")
                        self.presentAlert = true
                    case .failure:
                        print("Post creation failed!")
                        self.presentAlert = false
                }
            },  receiveValue: { (response: Post) in
                print("Post created successfully:", response)
            }).store(in: &cancellables)
    }
    
}

    // specify all api params keys
struct ApiKeys {
    static let TITLE = "title"
    static let BODY = "body"
    static let ID = "id"
    static let USERID = "userId"
}
