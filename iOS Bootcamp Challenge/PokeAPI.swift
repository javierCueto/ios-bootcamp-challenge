//
//  PokeAPI.swift
//  iOS Bootcamp Challenge
//
//  Created by Jorge Benavides on 26/09/21.
//

import Foundation

class PokeAPI {

    static let shared = PokeAPI()
    static let baseURL = "https://pokeapi.co/api/v2/"

    // TODO: Implements generics to merge this methods into one
    
    @discardableResult
    func get<T: Decodable>(url: String, onCompletion: @escaping(T?, Error?) -> Void) -> URLSessionDataTask? {
        let path = url.replacingOccurrences(of: PokeAPI.baseURL, with: "")
        let task = URLSession.mock.dataTask(with: PokeAPI.baseURL + path, completionHandler: { data, _, error in
            guard let data = data else {
                onCompletion(nil, error)
                return
            }
            do {
                let entity = try JSONDecoder().decode(T.self, from: data)
                onCompletion(entity, error)
            } catch {
                onCompletion(nil, error)
            }
        })
        task?.resume()
        return task
    }
    
    func getListPokemon(onCompletion: @escaping([Pokemon]) ->Void) {
        var pokemons = [Pokemon]()
        let group = DispatchGroup()
        PokeAPI.shared.get(url: "pokemon?limit=30", onCompletion: { (list: PokemonList?, _) in
            guard let list = list else { return }
            list.results.forEach { result in
                group.enter()
                PokeAPI.shared.get(url: "/pokemon/\(result.id)/", onCompletion: { (pokemon: Pokemon?, _) in
                    guard let pokemon = pokemon else { return }
                    pokemons.append(pokemon)
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                onCompletion(pokemons)
            }
        })
  
    }
    
    
}
