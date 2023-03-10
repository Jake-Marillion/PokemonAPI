//
//  PokemonError.swift
//  PokemonAPI
//
//  Created by Jacob Marillion on 2/4/23.
//

import Foundation

enum PokemonError: LocalizedError {
    
    //What we see (as dev)
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    //What the user sees
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach PokeAPI.co"
        case .thrownError(let error):
            return error.localizedDescription
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data."
        }
    }
}
