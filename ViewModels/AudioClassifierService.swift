//
//  AudioClassifierService.swift
//  WickedClassifier
//
//  Created by Clara on 12/08/26.
//
import Foundation
import CoreML
import SoundAnalysis

class AudioClassifierService {
    
    // Callback que retorna o resultado: (Nome da Música, Confiança entre 0 e 1)
    typealias ClassificationResult = (identifier: String, confidence: Double)
    
    /// Analisa o arquivo de áudio gravado e executa o callback com o resultado da classificação
    func classifyAudio(fileURL: URL, completion: @escaping (Result<ClassificationResult, Error>) -> Void) {
        do {
            // 1. Instancia o modelo CoreML do Wicked
            let defaultConfig = MLModelConfiguration()
            let mlModel = try WickedClassifier(configuration: defaultConfig).model
            
            // 2. Cria a Request do SoundAnalysis
            let request = try SNClassifySoundRequest(mlModel: mlModel)
            
            // 3. Cria o Analyzer com a URL do arquivo .wav
            let analyzer = try SNAudioFileAnalyzer(url: fileURL)
            
            // 4. Instancia o Observer
            let observer = SoundObserver { result in
                completion(result)
            }
            
            // 5. Adiciona a request e analisa
            try analyzer.add(request, withObserver: observer)
            analyzer.analyze()
            
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Observer Interno do SoundAnalysis
private class SoundObserver: NSObject, SNResultsObserving {
    private let completion: (Result<AudioClassifierService.ClassificationResult, Error>) -> Void
    private var hasResponded = false
    
    init(completion: @escaping (Result<AudioClassifierService.ClassificationResult, Error>) -> Void) {
        self.completion = completion
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Evita disparar múltiplos callbacks se houver mais de uma janelamento
        guard !hasResponded,
              let classificationResult = result as? SNClassificationResult,
              let topClassification = classificationResult.classifications.first else { return }
        
        hasResponded = true
        let data = (identifier: topClassification.identifier, confidence: topClassification.confidence)
        completion(.success(data))
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        if !hasResponded {
            hasResponded = true
            completion(.failure(error))
        }
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("Análise de áudio concluída.")
    }
}
