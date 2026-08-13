////
////  RecorderViewModel.swift
////  WickedClassifier
////
////  Created by Clara on 12/08/26.
////
//
//import Foundation
//import SwiftUI
//import AVFoundation
//import Combine
//
//class RecorderViewModel: NSObject, ObservableObject {
//    @Published var isRecording: Bool = false
//    @Published var permissionGranted: Bool = false
//    @Published var recordedAudioURL: URL?
//    
//    private var audioRecorder: AVAudioRecorder?
//    
//    // Propriedade para verificar se está rodando no Xcode Preview
//    private var isRunningInPreview: Bool {
//        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
//    }
//    
//    override init() {
//        super.init()
//        checkPermission()
//    }
//    
//    // MARK: - Permissão de Microfone (Atualizado para iOS 17+)
//    func checkPermission() {
//        // Se estiver no Preview do Xcode, apenas simula a permissão e encerra
//        if isRunningInPreview {
//            self.permissionGranted = true
//            return
//        }
//        
//        #if os(iOS)
//        if #available(iOS 17.0, *) {
//            // Nova API do iOS 17+
//            switch AVAudioApplication.shared.recordPermission {
//            case .granted:
//                DispatchQueue.main.async { self.permissionGranted = true }
//            case .denied:
//                DispatchQueue.main.async { self.permissionGranted = false }
//            case .undetermined:
//                AVAudioApplication.requestRecordPermission { granted in
//                    DispatchQueue.main.async { self.permissionGranted = granted }
//                }
//            @unknown default:
//                break
//            }
//        } else {
//            // Fallback para versões anteriores ao iOS 17
//            switch AVAudioSession.sharedInstance().recordPermission {
//            case .granted:
//                DispatchQueue.main.async { self.permissionGranted = true }
//            case .denied:
//                DispatchQueue.main.async { self.permissionGranted = false }
//            case .undetermined:
//                AVAudioSession.sharedInstance().requestRecordPermission { granted in
//                    DispatchQueue.main.async { self.permissionGranted = granted }
//                }
//            @unknown default:
//                break
//            }
//        }
//        #endif
//    }
//    
//    // MARK: - Controle de Gravação
//    func toggleRecording() {
//        if isRecording {
//            stopRecording()
//        } else {
//            startRecording()
//        }
//    }
//    
//    private func startRecording() {
//        // No Preview, apenas simula a alternância de estado sem ligar o microfone
//        if isRunningInPreview {
//            withAnimation { isRecording = true }
//            return
//        }
//        
//        guard permissionGranted else {
//            checkPermission()
//            return
//        }
//        
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetoothHFP])
//            try audioSession.setActive(true)
//            
//            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let audioFileURL = documentsPath.appendingPathComponent("wicked_input.wav")
//            
//            try? FileManager.default.removeItem(at: audioFileURL)
//            
//            let settings: [String: Any] = [
//                AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                AVSampleRateKey: 16000.0,
//                AVNumberOfChannelsKey: 1,
//                AVLinearPCMBitDepthKey: 16,
//                AVLinearPCMIsBigEndianKey: false,
//                AVLinearPCMIsFloatKey: false
//            ]
//            
//            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
//            audioRecorder?.record()
//            
//            withAnimation {
//                isRecording = true
//            }
//            
//        } catch {
//            print("Erro ao iniciar a gravação: \(error.localizedDescription)")
//        }
//    }
//    
//    func stopRecording() {
//        if isRunningInPreview {
//            withAnimation { isRecording = false }
//            return
//        }
//        
//        audioRecorder?.stop()
//        recordedAudioURL = audioRecorder?.url
//        
//        try? AVAudioSession.sharedInstance().setActive(false)
//        
//        withAnimation {
//            isRecording = false
//        }
//        
//        if let url = recordedAudioURL {
//            print("Áudio gravado salvo em: \(url)")
//        }
//    }
//}
//import Foundation
//import AVFoundation
//import Combine
//
//class RecorderViewModel: ObservableObject {
//    @Published var isRecording: Bool = false
//    @Published var recordedAudioURL: URL? = nil
//    @Published var detectedSong: WickedSong = WickedSong.unknown
//    @Published var confidencePercentage: String = "0%"
//    
//    private var audioRecorder: AVAudioRecorder?
//
//    init() {}
//
//    func toggleRecording() {
//        if isRecording {
//            stopRecording()
//        } else {
//            startRecording()
//        }
//    }
//
//    func startRecording() {
//        let audioSession = AVAudioSession.sharedInstance()
//        
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetoothHFP])
//            try audioSession.setActive(true)
//
//            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let audioFilename = documentPath.appendingPathComponent("wicked_input.wav")
//
//            let settings: [String: Any] = [
//                AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                AVSampleRateKey: 44100.0,
//                AVNumberOfChannelsKey: 1,
//                AVLinearPCMBitDepthKey: 16,
//                AVLinearPCMIsBigEndianKey: false,
//                AVLinearPCMIsFloatKey: false
//            ]
//
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder?.record()
//            
//            DispatchQueue.main.async {
//                self.isRecording = true
//                self.recordedAudioURL = nil
//            }
//        } catch {
//            print("Erro ao iniciar gravação: \(error.localizedDescription)")
//        }
//    }
//
//    func stopRecording() {
//        audioRecorder?.stop()
//        let savedURL = audioRecorder?.url
//        
//        DispatchQueue.main.async {
//            self.isRecording = false
//            self.recordedAudioURL = savedURL
//        }
//    }
//}
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

            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("wicked_input.wav")

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

    func stopRecording(completion: (() -> Void)? = nil) {
            audioRecorder?.stop()
            let savedURL = audioRecorder?.url
            
            DispatchQueue.main.async {
                self.isRecording = false
                self.recordedAudioURL = savedURL
            }
            
            // Garante que só avança quando a classificação terminar
            if let fileURL = savedURL {
                self.classifyAudio(fileURL: fileURL) {
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            } else {
                completion? ()
            }
        }

        private func classifyAudio(fileURL: URL, completion: @escaping () -> Void) {
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
                        completion()
                    }
                }

                try analyzer.add(snModel, withObserver: resultsObserver)
                analyzer.analyze()

            } catch {
                print("Erro ao classificar o áudio: \(error.localizedDescription)")
                completion()
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
        guard let classificationResult = result as? SNClassificationResult,
              let bestClassification = classificationResult.classifications.first else { return }

        // Retorna o rótulo com maior nível de confiança
        completion(bestClassification.identifier, bestClassification.confidence)
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Erro na requisição do SoundAnalysis: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("Análise concluída com sucesso.")
    }
}
