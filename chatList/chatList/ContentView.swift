//
//  ContentView.swift
//  chatList
//
//  Created by Sergey Ivchenko on 30.08.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var messages: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var timer: Timer? = nil
    @State private var isAutoScrollEnabled = true
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages) { item in
                            ChatMessageView(message: item, direction: item.direction)
                                .background(GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            if item.id == messages.last?.id {
                                                let isVisible = geometry.frame(in: .global).maxY < UIScreen.main.bounds.height
                                                isAutoScrollEnabled = isVisible
                                            }
                                        }
                                })
                        }
                    }
                    .padding()
                    .onChange(of: messages.count) { _, _ in
                        if isAutoScrollEnabled {
                            withAnimation {
                                if let lastMessage = messages.last {
                                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .gesture(DragGesture().onChanged { _ in
                        isAutoScrollEnabled = false
                    })
                }
            }
            HStack {
                TextField("Enter message", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isInputFocused)
            }
            .padding()
        }
        .onTapGesture {
            isInputFocused = false
        }
        .onAppear {
            startMessageTimer()
        }
        .onDisappear {
            stopMessageTimer()
        }
    }

    func startMessageTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            addRandomMessage()
        }
    }

    func stopMessageTimer() {
        timer?.invalidate()
    }

    func addRandomMessage() {
        let randomMessages = [
            "Hello!",
            "How are you?",
            "This is a random message.",
            "Keep going! Keep going! Keep going! Keep going! Keep going!",
            "Another message for you. Another message for you. Another message for you. Another message for you. "
        ]
        let randomMessage = randomMessages.randomElement() ?? "Default Message"
        let randomDirection: ChatMessageDirection = Bool.random() ? .left : .right
        messages.append(ChatMessage(text: randomMessage, direction: randomDirection))
    }
}

#Preview {
    ContentView()
}
