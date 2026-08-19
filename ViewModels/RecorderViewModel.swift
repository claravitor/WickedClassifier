//
//  RecorderViewModel.swift
//  WickedClassifier
//
//  Created by Clara on 12/08/26.
//

import Foundation
import AVFoundation
import Combine
import SoundAnalysis
import CoreML

class RecorderViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var recordedAudioURL: URL? = nil
    @Published var detectedSong: WickedSong = WickedSong.unknown
    @Published var confidencePercentage: String = "0%"
    
    private var audioRecorder: AVAudioRecorder?

    init() {}

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetoothHFP])
            try audioSession.setActive(true)

            let documentURL = URL.documentsDirectory
            let audioFilename = documentURL.appendingPathComponent("wicked_input.wav")
            
            print(audioFilename)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ]

            // Reseta a música para o estado inicial antes da nova gravação
            DispatchQueue.main.async {
                self.detectedSong = WickedSong.unknown
                self.confidencePercentage = "0%"
                self.isRecording = true
                self.recordedAudioURL = nil
            }

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()

        } catch {
            print("Erro ao iniciar gravação: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
            audioRecorder?.stop()
            let savedURL = audioRecorder?.url
            
            DispatchQueue.main.async {
                self.isRecording = false
                self.recordedAudioURL = savedURL
            }
            
            // Garante que só avança quando a classificação terminar
            if let fileURL = savedURL {
                self.classifyAudio(fileURL: fileURL)
            }
        }

        private func classifyAudio(fileURL: URL) {
            do {
                let modelConfig = MLModelConfiguration()
                let classifierModel = try WickedClassifier(configuration: modelConfig).model
                let snModel = try SNClassifySoundRequest(mlModel: classifierModel)

                let analyzer = try SNAudioFileAnalyzer(url: fileURL)
                let resultsObserver = ResultsObserver { topIdentifier, confidence in
                    DispatchQueue.main.async {
                        print("--> MÚSICA DETECTADA PELA IA: \(topIdentifier) (\(confidence * 100)%)")
                        self.detectedSong = WickedSong.from(identifier: topIdentifier)
                        self.confidencePercentage = String(format: "%.0f%%", confidence * 100)
                    }
                }

                try analyzer.add(snModel, withObserver: resultsObserver)
                analyzer.analyze()

            } catch {
                print("Erro ao classificar o áudio: \(error.localizedDescription)")
            }
        }
}

// MARK: - Classe auxiliar para receber os resultados do SoundAnalysis
class ResultsObserver: NSObject, SNResultsObserving {
    private let completion: (String, Double) -> Void

    init(completion: @escaping (String, Double) -> Void) {
        self.completion = completion
    }

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classificationResult = result as? SNClassificationResult, let bestClassification = classificationResult.classifications.first else { return }
        // Retorna o rótulo com maior nível de confiança
        let pair = (bestClassification.identifier, bestClassification.confidence)
        completion(bestClassification.identifier, bestClassification.confidence)
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Erro na requisição do SoundAnalysis: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("Análise concluída com sucesso.")
    }
}


protocol Animal {
    func emitirSom()
}

class Cachorro: Animal {
    func emitirSom() {
        print("auau")
    }
    
    
}

class Gato: Animal {
    func emitirSom() {
        print("miau")
    }
}
