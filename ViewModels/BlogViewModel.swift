//
//  BlogViewModel.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/13/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class BlogViewModel: ObservableObject{
    @Published var posts: [Post]?
    
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    @Published var createPost = false
    @Published var isWriting = false
    func fetchPosts() async {
        do {
            let db = Firestore.firestore().collection("Blog")
            let posts = try await db.getDocuments()
            DispatchQueue.main.async { // Make UI updates on the main thread
                self.posts = posts.documents.compactMap { post in
                    return try? post.data(as: Post.self)
                }
            }
        } catch {
            alertMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deletePost(post: Post){
        guard let _ = posts else {return}
        let index = posts?.firstIndex(where: {currentPost in
            return currentPost.id == post.id
        }) ?? 0
        
        withAnimation{posts?.remove(at: index)}
    }
    
    func writePost(content: [PostContent],author: String,postTitle: String){
        guard Auth.auth().currentUser != nil else {
            return
        }
        do{
            
            withAnimation{
                isWriting = true
            }
            let post = Post(title: postTitle, author: author, postContent: content, date: Timestamp(date: Date()))
            let _ = try Firestore.firestore().collection("Blog").document().setData(from: post)
            withAnimation{
                posts?.append(post)
                isWriting = true
                createPost = false
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
