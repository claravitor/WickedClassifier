//
//  ResultsView.swift
//  WickedClassifier
//
//  Created by Clara on 11/08/26.
//

import SwiftUI

struct ResultsView: View {
    // 1. Conexão Binding para voltar à ListeningView
    @Binding var isPresented: Bool
    let song: WickedSong
    let percentageText: String

    let backgroundColor = Color.pinkbackground

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - 1. Cabeçalho / Título
                    Text("A MÚSICA É...")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.pinktext)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)

                    // MARK: - 2. Subtítulo / Descrição da Música
                    Text("A música tocada é de wicked!!! Você deve ser muito fã.")
                        .font(.system(size: 20, weight: .regular, design: .serif))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)

                    // MARK: - 3. Imagem do Resultado
                    Image(song.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .clipped()

                    // MARK: - 4. Card de Resultado
                    ResultsCardView(
                     title: song.title,
                     description: "O modelo prevê que essa música é a mais provável de estar tocando",
                     percentage: percentageText,
                     onRetry: {
                            isPresented = false // Fecha a view e volta para tentar novamente
                    }
                )
                    .padding(.top, 8)

                }
                .padding(.vertical, 20)
                .padding(.horizontal, 18)
            }
        }
    }
}

// MARK: - Card Componente
struct ResultsCardView: View {
    var title: String
    var description: String 
    var percentage: String 
    var buttonTitle: String = "Tentar novamente"
    var onRetry: (() -> Void)? = nil

    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color.pinktext)

                Text(description)
                    .font(.system(size: 17, weight: .regular, design: .serif))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 8)

                Text(percentage)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(Color.pinktext)

                Button(action: {
                    onRetry?()
                }) {
                    Text(buttonTitle)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.pinkbutton)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
}

// MARK: - Preview
#Preview {
    ResultsView(isPresented: .constant(true), song: WickedSong.unknown, percentageText: "100%")
}
