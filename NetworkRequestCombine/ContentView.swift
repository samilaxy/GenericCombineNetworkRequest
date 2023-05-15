//
//  ContentView.swift
//  NetworkRequestCombine
//
//  Created by Noye Samuel on 26/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var selection = 0
    @StateObject private var viewModel = PostViewModel()
    
        //  var combineImp = CombineImp()
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .gray //UIColor(Color("NavColor"))
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                TabView(selection: $selection) {
                    List(viewModel.posts) { post in
                        Text(post.title).foregroundColor(.secondary)
                    }
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Posts")
                    }
                    .tag(0)
                    
                    CreatePostView()
                        .tabItem {
                            Image(systemName: "plus.app.fill")
                            Text("Add Post")
                        }
                        .tag(1)

                        List(viewModel.users) { user in
                            Text(user.name).foregroundColor(.secondary)
                        }
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("users")
                        }
                        .tag(2)
                        
                    }  .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarTitle("Posts", displayMode: .automatic)
                        .foregroundColor(.secondary)
                        .edgesIgnoringSafeArea(.all)
                        .padding(10)
                        .accentColor(.red)
                        .onAppear() {
                            UITabBar.appearance().barTintColor = UIColor(Color(.systemBackground))
                        }
                }
                
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}









struct AwaitAsyncImp {
    
}
