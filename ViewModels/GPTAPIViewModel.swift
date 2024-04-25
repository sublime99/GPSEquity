//
//  GPTAPIViewModel.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/24/24.
//

import Foundation
import OpenAISwift

final class ChatViewModel: ObservableObject {
    @Published var messages: [GPTChatMessage] = [] // Published property for chat messages

    private var openAI: OpenAISwift?

    init() {}

    func setupOpenAI() {
        let config: OpenAISwift.Config = .makeDefaultOpenAI(apiKey: "sk-proj-pkDFUePGN66Ti9EoE3eCT3BlbkFJWRhZ6eJh3PwprVSl8vyk")
        openAI = OpenAISwift(config: config) // Initialize OpenAI
    }

    func sendUserMessage(_ message: String) {
        print("Sending Message--------------")
        let userMessage = GPTChatMessage(message: message, isUser: true)
        messages.append(userMessage) // Append user message to chat history
        print(userMessage)
        print()
        print(messages)
        openAI?.sendCompletion(with: message, maxTokens: 500) { [weak self] result in
            switch result {
            case .success(let model):
                if let response = model.choices?.first?.text {
                    self?.receiveBotMessage(response) // Handle bot's response
                }
            case .failure(_):
                // Handle any errors during message sending
                print("**********")
                print(result)
                print("**********")
                break
            }
        }
    }

    private func receiveBotMessage(_ message: String) {
        print("Bot Message Received--------------------")
        let botMessage = GPTChatMessage(message: message, isUser: false)
        messages.append(botMessage) // Append bot message to chat history
    }
}
