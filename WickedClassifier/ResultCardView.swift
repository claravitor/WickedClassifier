//
//  ResultCardView.swift
//  WickedClassifier
//
//  Created by Clara on 11/08/26.
//
//

import SwiftUI

// MARK: - 1. Estilo Personalizado para o GroupBox
struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            configuration.content
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity)
        .background(Color.cardbackground)
        .cornerRadius(32) 
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
}
struct ResultCardView: View {
    var title: String = "Popular"
    var description: String = "O modelo prevê que essa musica é a mais provável de estar tocando"
    var percentage: String = "95,5%"
    var buttonTitle: String = "Tentar novamente"
    var onRetry: (() -> Void)? = nil

    var body: some View {
        GroupBox {
            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color.pinktext)

                Text(description)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 10)

                Text(percentage)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color.pinktext)
                    .padding(.vertical, 5)

                Button(action: {
                    onRetry?()
                }) {
                    Text(buttonTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.pinkbutton)
                        .clipShape(Capsule())
                }
            }
        }
        .groupBoxStyle(CardGroupBoxStyle()) 
        .padding(.horizontal, 10)
    }
}

#Preview {
    ZStack {
        Color.gray
            .ignoresSafeArea()
        
        ResultCardView {
            print("Botão acionado!")
        }
    }
}
