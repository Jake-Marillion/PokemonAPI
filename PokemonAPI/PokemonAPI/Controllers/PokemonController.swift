//
//  PokemonController.swift
//  PokemonAPI
//
//  Created by Jacob Marillion on 2/4/23.
//

import UIKit

class PokemonController {
    
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/")
    static let pokemonEndpoint = "pokemon"
    
    static func fetchPokemon(searchTerm: String, completion: @escaping (Result<Pokemon, PokemonError>) -> Void) {
        //URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let pokemonURL = baseURL.appendingPathComponent(pokemonEndpoint)
        let searchTermURL = pokemonURL.appendingPathComponent(searchTerm.lowercased())
        print(searchTermURL)
        
        //Data Task
        URLSession.shared.dataTask(with: searchTermURL) { data, _, error in
            
            //Error Handling
            if let error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            //Check for Data
            guard let data = data else { return completion(.failure(.noData)) }
            
            //Decode Data
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                return completion(.success(pokemon))
            } catch {
                print(error, error.localizedDescription)
                
                //Return
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchSprite(pokemon: Pokemon, shinyOrClassic: Bool, completion: @escaping (Result<UIImage, PokemonError>) -> Void) {
        
        let imageIndicator = shinyOrClassic
        //URL
        var spriteURL = pokemon.sprites.classicSpriteURL
        
        if imageIndicator == true {
            spriteURL = pokemon.sprites.classicSpriteURL
        } else {
            spriteURL = pokemon.sprites.shinySpriteURL
        }
        
        //Data Task
        URLSession.shared.dataTask(with: spriteURL) { (data, _, error) in
            //Error Handling
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            //Check for Data
            guard let data = data else { return completion(.failure(.noData)) }
                      
            //Decode Data
            guard let sprite = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            
            //Return
            return completion(.success(sprite))
                                                           
        }.resume()
    }
}
