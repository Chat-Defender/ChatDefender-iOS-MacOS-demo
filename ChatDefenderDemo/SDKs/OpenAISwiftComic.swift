//
//  OpenAISwiftComic.swift
//  ChatDefenderDemo
//
//  Created by Rob Jonson on 21/03/2023.
//

import Foundation
import OpenAISwift

struct OpenAISwiftComic {
    static func fetchJoke(subject:String) async -> String? {
        let openAiSwift = OpenAISwift(authToken: Config.key)
        
        let chat: [ChatMessage] = [
            ChatMessage(role: .system,
                        cdContent: CDMessage(key: "comic1")
                       ),
            ChatMessage(role: .user,
                        cdContent: CDMessage(key: "substitute_joke",
                                             variables: ["subject" : subject])
                       )
        ]
        
        do {
            let result = try await openAiSwift.sendChat(with: chat)
            return result.choices?.first?.message.content
        } catch  {
            print("RequestFailed: \(error)")
            return nil
        }   
    }
}
