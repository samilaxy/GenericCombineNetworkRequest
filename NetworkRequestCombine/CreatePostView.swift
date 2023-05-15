    //
    //  CreatePostView.swift
    //  NetworkRequestCombine
    //
    //  Created by Noye Samuel on 11/05/2023.
    //

import SwiftUI


struct CreatePostView: View {
    @State var title: String = ""
    @State var message: String = ""
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack{
                RoundedRectangle(cornerRadius: 5).stroke()
                    .frame(height: 50)
                    .background(Color.secondary.opacity(0.1))
                TextField("Title", text: $title)
                    .background(Color.clear)
                    .padding()
            }
            .frame(height: 50)
            TextEditor(text: $message)
                .background(Color.secondary.opacity(0.2))
                .border(Color.gray, width: 2)
                .frame(height: 200)
            Button {
                viewModel.createPost(title: title, body: message)
            } label: {
                ZStack{
                    Rectangle()
                        .frame(height: 50)
                    Text("Submit")
                        .foregroundColor(.white)
                }
            }
            .alert("Post Added", isPresented: $viewModel.presentAlert, actions: {
                Button("OK", role: .cancel) { }
            })
            Spacer()
        }
        .padding()
        .padding(.top, 50)
    }
}




struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
