//
//  ContentView.swift
//  ChatDefenderDemo
//
//  Created by Rob Jonson on 20/03/2023.
//

import SwiftUI


struct ContentView: View {
    @State private var subject:String = ""
    @MainActor
    @State private var processing:Bool = false
    @MainActor
    @State private var joke:String? = nil
    
    var body: some View {
        VStack {
            if let joke {
                Text(joke)
            }
            
            TextField("Joke Subject", text: $subject)
                .padding()
                .border(.gray)
            
            Button {
                getJoke()
            } label: {
                Text(joke == nil ? "Tell me a Joke" : "Tell Another !")
            }
            
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
    func getJoke() {
          
        processing = true
        Task {
            joke = await OpenAISwiftComic.fetchJoke(subject: subject)
            processing = false
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
