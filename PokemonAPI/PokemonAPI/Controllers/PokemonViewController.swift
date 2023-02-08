//
//  ViewController.swift
//  PokemonAPI
//
//  Created by Jacob Marillion on 2/4/23.
//

import UIKit

class PokemonViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var pokeNameLabel: UILabel!
    @IBOutlet weak var pokeSearchBar: UISearchBar!
    @IBOutlet weak var pokeIdLabel: UILabel!
    
    //MARK: - Lifecycle Methods
    var shinyOrClassic: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokeSearchBar.delegate = self
        
        
    }

    //MARK: - Methods

    func fetchSpriteAndUpdateViews(pokemon: Pokemon, shinyOrClassic: Bool) {
        PokemonController.fetchSprite(pokemon: pokemon, shinyOrClassic: self.shinyOrClassic) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let sprite):
                    self.pokeImageView.image = sprite
                    self.pokeNameLabel.text = pokemon.name
                    self.pokeIdLabel.text = String(pokemon.id)
                    
                    if self.shinyOrClassic == true {
                        self.shinyOrClassic = false
                    } else {
                        self.shinyOrClassic = true
                    }
                    
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}

extension PokemonViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text,
              !searchTerm.isEmpty else { return }
        
        PokemonController.fetchPokemon(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemon):
                    self.fetchSpriteAndUpdateViews(pokemon: pokemon, shinyOrClassic: self.shinyOrClassic)
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}
