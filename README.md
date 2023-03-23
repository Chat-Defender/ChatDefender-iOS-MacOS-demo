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

The relevant interaction code for OpenAISwift is in OpenAISwiftComic

```
struct OpenAISwiftComic {
    static func fetchJoke(subject:String) async -> String? {
        let openAiSwift = OpenAISwift(authToken: Config.key)
        
        let chat: [ChatMessage] = [
            ChatMessage(role: .user,
                        cd_key: "substitute_joke",
                        cd_variables: ["subject" : subject])
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
