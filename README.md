#  Chat Defender iOS/MacOS Demo

This SwiftUI app demonstrates using [Chat Defender](https://chatdefender.com/) to proxy requests to openai

It uses the drop-in replacement sdk for [OpenAISwift](https://github.com/Chat-Defender/OpenAISwift)

[Chat Defender](https://chatdefender.com/) allows you to avoid exposing your openai keys and prompts.

It also lets you modify your prompts without needing to release an update.

## Usage

Set up your account at [ChatDefender.com](https://chatdefender.com)

Add your chat defender api key in Config

Configure the sample message in your Chat Defender [messages page](https://chatdefender.com/messages)

It should have the following values

* Title: Any title you want!
* Key: substitute_joke
* Prompt: Limit Prose: Please tell me a joke about ##subject##!

Run the app!

## How it works

The app demonstrates using the OpenAISwift and the SwiftOpenAI packages!
The SwiftOpenIA package has the major advantage that it supports streaming responses.


The relevant interaction code for OpenAISwift is in [OpenAISwiftComic](https://github.com/Chat-Defender/ChatDefender-iOS-MacOS-demo/blob/main/ChatDefenderDemo/SDKs/OpenAISwiftComic.swift)

```
struct OpenAISwiftComic {
    static func fetchJoke(subject:String) async -> String? {
        let openAiSwift = OpenAISwift(authToken: Config.key)
        
        let chat: [ChatMessage] = [
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
```

The code for SwiftOpenAI is marginally more complex, but still straightforward [SwiftOpenAIComic]https://github.com/Chat-Defender/ChatDefender-iOS-MacOS-demo/blob/main/ChatDefenderDemo/SDKs/SwiftOpenAIComic.swift


```

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

```



