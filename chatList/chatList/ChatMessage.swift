//
//  ChatMessage.swift
//  chatList
//
//  Created by Sergey Ivchenko on 30.08.2024.
//

import SwiftUI

enum ChatMessageDirection {
    case left
    case right
}

struct ChatMessage: Hashable, Identifiable {
    let id = UUID()
    let text: String
    let direction: ChatMessageDirection
}

struct ChatMessageView: View {
    let message: ChatMessage
    let direction: ChatMessageDirection
    
    var body: some View {
        HStack {
            if direction == .left {
                Spacer()
            }
            
            Text(message.text)
                .padding()
                .background(direction == .left ? Color.green : Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                .listRowSeparator(.hidden)
                .overlay(alignment: direction == .left ? .bottomLeading: .bottomTrailing) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.title)
                        .rotationEffect(.degrees(direction == .left ? 45 : -45))
                        .offset(x: direction == .left ? -10 : 10, y: 10)
                        .foregroundColor(direction == .left ? Color.green : Color.blue)
                }
            
            if direction == .right {
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
}

