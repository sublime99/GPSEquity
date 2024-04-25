//
//  Home.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/13/24.
//

import SwiftUI
import FirebaseAuth


struct Home: View {
    @StateObject var blogData = BlogViewModel()
    @State private var isUserAuthenticated = false
    
    // Color Based on ColorScheme...
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        VStack{
            
            Text("GPSEquity - Blog")
                .fontWeight(.bold)
                .padding(.leading, -8) // adjust the padding as needed
            
            if isUserAuthenticated{
                if let posts = blogData.posts{
                    
                    // No Posts...
                    if posts.isEmpty{
                        
                        (
                            Text(Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                            +
                            
                            Text("Start Writing Blog")
                        )
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    }
                    else{
                        
                        List(posts){post in
                            
                            // CardView...
                            CardView(post: post)
                            // Swipe to delete...
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    
                                    Button(role: .destructive) {
                                        blogData.deletePost(post: post)
                                    } label: {
                                        
                                        Image(systemName: "trash")
                                    }
                                    
                                }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                else{
                    
                    ProgressView()
                }
                Spacer()
                
                Button(action: {
                    // handle sign out action
                    try? Auth.auth().signOut()
                    isUserAuthenticated = false
                }, label: {
                    Text("Sign Out")
                })
                .padding(.bottom) // align to the bottom of the screen
                
            } else {
                SignInView(isUserAuthenticated: $isUserAuthenticated)
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                
                // FAB Button...
                Button(action: {
                    if isUserAuthenticated{
                        blogData.createPost.toggle()
                    }
                }, label: {
                    
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundColor(scheme == .dark ? Color.black : Color.white)
                        .padding()
                        .background(.primary,in: Circle())
                })
                .padding()
                .foregroundStyle(.primary)
                
                ,alignment: .bottomTrailing
            )
        
        // fetching Blog Posts...
        .task {
            await blogData.fetchPosts()
        }
        .fullScreenCover(isPresented: $blogData.createPost, content: {
            
            // Create Post View....
            CreatePost()
                .overlay(
                    
                    ZStack{
                        
                        Color.primary.opacity(0.25)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .background(scheme == .dark ? .black : .white,in: RoundedRectangle(cornerRadius: 15))
                    }
                        .opacity(blogData.isWriting ? 1 : 0)
                )
                .environmentObject(blogData)
        })
        .alert(blogData.alertMsg, isPresented: $blogData.showAlert) {
            
        }
    }
    
    @ViewBuilder
    func CardView(post: Post)->some View{
        
        // Detail View...
        NavigationLink {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    Text("Written By: \(post.author)")
                        .foregroundColor(.gray)
                    
                    Text("DateF: \(            post.date.dateValue().formatted(date: .numeric, time: .shortened))")
                        .foregroundColor(.gray)
                    
                    ForEach(post.postContent){content in
                        
                        if content.type == .Image{
                            WebImage(url: content.value)
                        }
                        else{
                            Text(content.value)
                                .font(.system(size: getFontSize(type: content.type)))
                                .lineSpacing(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(post.title)
            
        } label: {
            
            VStack(alignment: .leading, spacing: 12) {
                Text(post.title)
                    .fontWeight(.bold)
                HStack {
                    Text("Written by:")
                    Text(post.author)
                        .fontWeight(.semibold)
                    Spacer()
                    if let user = Auth.auth().currentUser {
                        if let photoURL = user.photoURL {
                            AsyncImage(url: photoURL)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            Text(post.date.dateValue().formatted(date: .numeric, time: .shortened))
                .font(.caption.bold())
                .foregroundColor(.gray)
            
        }
    }
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
