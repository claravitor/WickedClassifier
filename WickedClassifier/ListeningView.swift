import SwiftUI

struct ListeningView: View {
    private let backgroundColor = Color.greenbackgroung
    private let circleBackgroundColor = Color.greencircle
    private let waveColor = Color.greenwave

    @State private var isListening = true

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Cabeçalho e Descrição
                    VStack(spacing: 16) {
                        Text("QUE MUSICA ESTÁ TOCANDO?")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("Cante ou Toque uma música. O modelo identificará se é de Wicked ou não, se for, ele retorna o nome da mesma.")
                            .font(.custom("Georgia", size: 24))
                            .foregroundColor(Color.black.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

//                     MARK: - Botão Central de Áudio
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(circleBackgroundColor)
                                .frame(width: 200, height: 200)
                                .scaleEffect(isListening ? 1.04 : 1.0)
                                .animation(
                                    isListening
                                        ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                                        : .default,
                                    value: isListening
                                )
                                .padding(60)

                            // Resizable impede que o SF Symbol expanda a tela
                            Image(systemName: "waveform")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 150)
                                .foregroundColor(waveColor)
                                .symbolEffect(.variableColor.iterative, options: .repeating, isActive: isListening)
                        }
                        .contentShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                isListening.toggle()
                            }
                        }

                        Text(isListening ? "Ouvindo..." : "Toque para ouvir")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ListeningView()
}
