//
//  ResultsView.swift
//  WickedClassifier
//
//  Created by Clara on 11/08/26.
//

import SwiftUI

struct ResultView: View {

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
                        .foregroundColor(.black)
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
                    // Troque "wicked_image" pelo nome do seu Asset de imagem no Xcode
                    Image("clara")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .clipped()

                    // MARK: - 4. Card de Resultado (GroupBox personalizado)
                    ResultCardView {
                        print("Ação: Tentar Novamente acionada!")
                    }
                    .padding(.top, 8)

                }
                .padding(.vertical, 20)

                .padding(.horizontal, 18)
            }
        }
    }
}

struct ResultsCardView: View {
    var title: String = "Popular"
    var description: String = "O modelo prevê que essa musica é a mais provável de estar tocando"
    var percentage: String = "100%"
    var buttonTitle: String = "Tentar novamente"
    var onRetry: (() -> Void)? = nil

    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color.black)

                Text(description)
                    .font(.system(size: 17, weight: .regular, design: .serif))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 8)

                Text(percentage)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(Color.black)

                Button(action: {
                    onRetry?()
                }) {
                    Text(buttonTitle)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
}

struct cardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.content
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.cardbackground)
        .cornerRadius(28)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    ResultView()
}
