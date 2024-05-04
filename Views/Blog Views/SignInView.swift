//
//  SignInView.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/13/24.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SignInView: View {
    @Binding var isUserAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var error: IdentifiableError?
    @State private var showWelcomeAlert = false

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            TextField("Email", text: $email)
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
            SecureField("Password", text: $password)
                .padding()
                .textContentType(.password)
            Button("Sign In") {
                signIn()
            }
            
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .padding()
            .alert(item: $error) { error in
                  Alert(title: Text("Error"), message: Text(error.localizedDescription))
              }
                 
            VStack {
                Text("Don't have an account?")
                Text("Just type your desired email and password, and click on:")
                    .multilineTextAlignment(.center)
                Button("Create Account") {
                    createAccount()
                }
                .foregroundColor(.blue)
            }
        }.background(.black)
        
//        .alert(isPresented: $showWelcomeAlert) {
//            Alert(title: Text("Welcome to GPSEquity - Blog"), message: Text("You have successfully signed in or signed up"), dismissButton: .default(Text("OK")))
//        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.error = IdentifiableError(error: error)
            } else {
                self.showWelcomeAlert = true
                self.isUserAuthenticated = true
                
            }
        }
    }
    
//    func createAccount() {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                self.error = IdentifiableError(error: error)
//            } else {
//                self.showWelcomeAlert = true
//                self.signIn()
//            }
//        }
//    }
    
    func createAccount() {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.error = IdentifiableError(error: error)
                } else if let user = result?.user {
                    self.addUserToFirestore(user: user) { success in
                        if success {
                            self.showWelcomeAlert = true
                            self.signIn()
                        } else {
                            self.error = IdentifiableError(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create user profile in Firestore."]))
                        }
                    }
                }
            }
        }
        
        // Function to add user to Firestore
        private func addUserToFirestore(user: User, completion: @escaping (Bool) -> Void) {
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "email": user.email ?? "",
                "created_at": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    completion(false)
                } else {
                    print("Document successfully written!")
                    completion(true)
                }
            }
        }
}

struct IdentifiableError: Identifiable {
    let id = UUID()
    let error: Error
    
    var localizedDescription: String {
        return error.localizedDescription
    }
}


