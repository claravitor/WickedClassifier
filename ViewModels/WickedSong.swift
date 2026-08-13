//
//  WickedSong.swift
//  WickedClassifier
//
//  Created by Clara on 12/08/26.
//
import SwiftUI

struct WickedSong {
    let identifier: String      // Nome vindo do Create ML
    let title: String           // Nome formatado para mostrar na tela
    let imageName: String       // Nome da imagem no Assets.xcassets
    let description: String     // Frase personalizada
    
    static let unknown = WickedSong(
        identifier: "unknow",
        title: "Musica nao reconhecida",
        imageName: "clara",
        description: "Não foi possível reconhecer a música com certeza.",
    )
    
    static func from(identifier: String) -> WickedSong {
        // Normaliza para ignorar espaços extras ou maiúsculas/minúsculas acidentais
        let clean = identifier.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch clean {
        case "as long as your mine":
            return WickedSong(
                identifier: clean,
                title: "As Long As You're Mine",
                imageName: "seeutenhovc",
                description: "A música identificada é de Wicked!ME MOSTRE O QUE É VIVER."
            )
            
        case "dancing throught life":
            return WickedSong(
                identifier: clean,
                title: "Dancing Through Life",
                imageName: "esodançar",
                description: "A música identificada é de Wicked!Vamo todos dançar nas Ozdust!!"
            )
            
        case "defying gravity":
            return WickedSong(
                identifier: clean,
                title: "Defying Gravity",
                imageName: "defyinggravity",
                description: "A música identificada é de Wicked! Olhem pro céu no Oeste!!"
            )
            
        case "for good":
            return WickedSong(
                identifier: clean,
                title: "For Good",
                imageName: "tudomudou",
                description: "A música identificada é de Wicked! tUdo mudou EeEemmM mim"
            )
            
        case "no good deed":
            return WickedSong(
                identifier: clean,
                title: "No Good Deed",
                imageName: "todobem",
                description: "A música identificada é de Wicked!NUUUNCA ajudou ninguém"
            )
            
        case "no one morns the wicked":
            return WickedSong(
                identifier: clean,
                title: "No One Mourns the Wicked",
                imageName: "semperdaoabruxa",
                description: "A música identificada é de Wicked! Olha lá, é a Glinda!!"
            )
            
        case "one short day":
            return WickedSong(
                identifier: clean,
                title: "One Short Day",
                imageName: "venha ver",
                description: "A música identificada é de Wicked! Esse Mundo Esmeralda"
            )
            
        case "popular":
            return WickedSong(
                identifier: clean,
                title: "Popular",
                imageName: "popular2", // Nome da imagem que você já usa
                description: "A música identificada é de Wicked!Vou te Popularizar"
            )
            
        case "thank goodness":
            return WickedSong(
                identifier: clean,
                title: "Thank Goodness",
                imageName: "quedia",
                description: "A música identificada é de Wicked! NÃO DÁ PRA SER MAIS FELIZ"
            )
            
        case "the wizard and i":
            return WickedSong(
                identifier: clean,
                title: "The Wizard and I",
                imageName: "omagicoeeu",
                description: "A música identificada é de Wicked!Na imensidão..."
            )
            
        case "what is this feeling":
            return WickedSong(
                identifier: clean,
                title: "What Is This Feeling?",
                imageName: "odio",
                description: "A música identificada é de Wicked!o nariz, a voixx, que ódio!!"
            )
            
        default:
            return WickedSong(
                identifier: "unknow",
                title: identifier.capitalized,
                imageName: "clara",
                description: "O modelo prevê que a música tocada não é do musical"
            )
        }
    }
}
