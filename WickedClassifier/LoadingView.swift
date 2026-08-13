//
//  LoadingView.swift
//  WickedClassifier
//
//  Created by Clara on 13/08/26.
//

import SwiftUI
import SceneKit

struct LoadingView: View {
    @State private var floatOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Fundo
            Color.pinkbackground
                .ignoresSafeArea()

            VStack(spacing: 32) {
                
                Wand3DScene(sceneName: "Glindas_Wand_WICKED.usdz")
                    .frame(width: 400, height: 350)
                    .offset(y: floatOffset)
                    .onAppear {
                        // Flutuação suave no SwiftUI
                        withAnimation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                        ) {
                            floatOffset = -12
                        }
                    }

                VStack(spacing: 8) {
                    Text("A CAMINHO DO WIZOMANIA")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.greenwave)

                    Text("Espera só um tic-tac...")
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(.pinktext.opacity(0.7))
                }
            }
        }
    }
}

struct Wand3DScene: UIViewRepresentable {
    let sceneName: String

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true

        if let scene = SCNScene(named: sceneName) {
            scnView.scene = scene
            
            if let rootNode = scene.rootNode.childNodes.first {
                
                let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 4.0)
                let repeatForever = SCNAction.repeatForever(rotateAction)
                rootNode.runAction(repeatForever)
            }
        }

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

// MARK: - Preview
#Preview {
    LoadingView()
}
