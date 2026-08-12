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
import Foundation
import AVFoundation
import Combine

class RecorderViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var recordedAudioURL: URL? = nil
    
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

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            DispatchQueue.main.async {
                self.isRecording = true
                self.recordedAudioURL = nil
            }
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
    }
}
