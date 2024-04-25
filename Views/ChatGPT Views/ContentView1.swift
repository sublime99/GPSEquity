//
//  ContentView.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/24/24.
//

import SwiftUI

struct ContentView1: View {
    @ObservedObject var viewModel: ChatViewModel
    
    @State private var newMessage = ""
    
    var body: some View {
        VStack {
            MessagesListView(messages: viewModel.messages) // Display chat messages
            HStack {
                TextField("Enter your message", text: $newMessage) // Input field
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Text("Send") // Button to send a message
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .onAppear {
            viewModel.setupOpenAI() // Initialize OpenAI when the view appears
        }
    }
    
    func sendMessage() {
        print("Clicked Send ------------")
        guard !newMessage.isEmpty else { return }
        viewModel.sendUserMessage(newMessage) // Send user's message to view model
        newMessage = "" // Clear the input field
    }
}

struct MessagesListView: View {
    var messages: [GPTChatMessage]
    
    var body: some View {
        List(messages) { message in
            MessageRow(message: message) // Display individual chat messages
        }
        .listStyle(.plain)
        .background(Color.clear)
    }
}

struct MessageRow: View {
    var message: GPTChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.message)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            } else {
                Text(message.message)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}



//
//
//struct ContentView1_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView1()
//    }
//}
