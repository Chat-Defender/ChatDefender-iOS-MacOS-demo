//
//  ContentView.swift
//  ChatDefenderDemo
//
//  Created by Rob Jonson on 20/03/2023.
//

import SwiftUI


struct ContentView: View {
    @State private var subject:String = "Cucumbers"
    @MainActor
    @State private var processing:Bool = false
    @MainActor
    @State private var joke:String = ""
    
    var body: some View {
        VStack(spacing:20) {

            Text(joke)
            
            TextField("Joke Subject", text: $subject)
                .padding()
                .border(.gray)
            
            Button {
                getJokeOpenAISwift()
            } label: {
                VStack {
                    Text("OpenAISwift")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(joke.isEmpty ? "Tell me a Joke" : "Tell Another !")
                }
            }
            .padding()
            .border(.gray)
            
            Button {
                getJokeSwiftOpenAI()
            } label: {
                VStack {
                    Text("SwiftOpenAI")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(joke.isEmpty ? "Tell me a Joke" : "Tell Another !")
                }
            }
            .padding()
            .border(.gray)
            
        }
        .disabled(processing)
        .padding()
        .overlay {
            if processing {
                ProgressView()
            }
        }
    }
      
    
    @MainActor
    func getJokeOpenAISwift() {     
        processing = true
        Task {
            joke = await OpenAISwiftComic.fetchJoke(subject: subject) ?? ""
            processing = false
        }
    }
    
    @MainActor
    //SwiftOpenAI supports streaming responses
    func getJokeSwiftOpenAI() {
        processing = true
        joke = ""
        Task {
            for await part in SwiftOpenAIComic.fetchJoke(subject: subject) {
                joke = joke + part
            }
            processing = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
