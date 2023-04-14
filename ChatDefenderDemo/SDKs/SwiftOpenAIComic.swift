//
//  SwiftOpenAIComic.swift
//  ChatDefenderDemo
//
//  Created by Rob Jonson on 14/04/2023.
//

import Foundation
import SwiftOpenAI

struct SwiftOpenAIComic {
    
    static func fetchJoke(subject:String) -> AsyncStream<String> {
        let openAI = SwiftOpenAI(apiKey: Config.key)
        
        let messages: [MessageChatGPT] = [
          MessageChatGPT(role: .user,
                         cdContent: CDMessage(key: "substitute_joke",
                                              variables: ["subject" : subject])
                        )
        ]
        
        let optionalParameters = ChatCompletionsOptionalParameters(stream: true)

 
        return AsyncStream<String> {
            continuation in
            Task {
                do {
                    let stream = try await openAI.createChatCompletionsStream(model: .gpt3_5(.turbo),
                                                                              messages: messages,
                                                                              optionalParameters: optionalParameters)
                    
                    for try await response in stream {
                        if let delta = response.choices.first?.delta?.content {
                            continuation.yield(delta)
                        }
                    }
                    continuation.finish()
                } catch {
                    print("Error: \(error)")
                    continuation.finish()
                }
            }
        }
    }
}
