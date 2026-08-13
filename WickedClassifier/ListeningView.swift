//
//  ListeningView.swift
//  WickedClassifier
//
//  Created by Clara on 10/08/26.
//
//

import SwiftUI

struct ListeningView: View {
    private let backgroundColor = Color.greenbackgroung
    private let circleBackgroundColor = Color.greencircle
    private let waveColor = Color.greenwave
    
    // Instancia a ViewModel do gravador
    @StateObject private var recorderVM = RecorderViewModel()
    @State private var navigateToResults: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Cabeçalho e Descrição
                        VStack(spacing: 16) {
                            Text("QUE MÚSICA ESTÁ TOCANDO?")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.greenwave)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Text("Cante ou toque uma música. O modelo identificará se é de Wicked ou não. Se for, ele retorna o nome da mesma.")
                                .font(.custom("Georgia", size: 20))
                                .foregroundColor(Color.black.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // MARK: - Botão Central de Áudio
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(circleBackgroundColor)
                                    .frame(width: 200, height: 200)
                                    .scaleEffect(recorderVM.isRecording ? 1.04 : 1.0)
                                    .animation(
                                        recorderVM.isRecording
                                        ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                                        : .default,
                                        value: recorderVM.isRecording
                                    )
                                    .padding(60)
                                
                                Image(systemName: "waveform")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 150)
                                    .foregroundColor(waveColor)
                                    .symbolEffect(.variableColor.iterative, options: .repeating, isActive: recorderVM.isRecording)
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                if recorderVM.isRecording {
                                    // Para a gravação e força a navegação imediata
                                    recorderVM.toggleRecording()
                                    navigateToResults = true
                                } else {
                                    recorderVM.toggleRecording()
                                }
                            }
                            
                            Text(recorderVM.isRecording ? "Ouvindo..." : "Toque para ouvir")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 20)
                    }
                }
                .scrollIndicators(.hidden)
            }
            // Navegação conectada ao NavigationStack
//            .navigationDestination(isPresented: $navigateToResults) {
//                ResultsView(isPresented: $navigateToResults, audiourl: recorderVM.recordedAudioURL)
//            }
            .navigationDestination(isPresented: $navigateToResults) {
                ResultsView(
                    isPresented: $navigateToResults,
                    song: recorderVM.detectedSong,
                    percentageText: recorderVM.confidencePercentage
                )
            }
            .onChange(of: recorderVM.recordedAudioURL) { _, newURL in
                if newURL != nil {
                    navigateToResults = true
                }
            }
        }
    }
}

struct ListeningView_Previews: PreviewProvider {
    static var previews: some View {
        ListeningView()
    }
}
