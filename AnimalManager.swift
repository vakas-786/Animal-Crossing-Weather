//
//  AnimalManager.swift
//  Clima
//
//  Created by Vakas Akhtar on 11/11/20.
//  Copyright © 2020 Vakas Akhtar . All rights reserved.
//

import Foundation

protocol AnimalManagerDelegate {
    func didUpdateAnimal(_ animalManager: AnimalManager, animal: AnimalModel)
    func didFailWithErrorAnimal(error: Error)
}

struct AnimalManager {
    let animalUrl = "https://serene-caverns-61931.herokuapp.com/animals"
    
    var delegate: AnimalManagerDelegate?

    func fetchAnimal() {
        let urlString = animalUrl
        fetchUrl(with: urlString)
    }
    
    func fetchUrl(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithErrorAnimal(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let animal = self.parseJSON(safeData) {
                        self.delegate?.didUpdateAnimal( self, animal: animal)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ animalData: Data) -> AnimalModel? {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(AnimalData.self, from: animalData)
            let quote = decodedData.quote
            let icon = decodedData.icon_url
            
            print(decodedData)
            
            let animal = AnimalModel(quote: quote, icon: icon)
            
            return animal
        } catch {
            delegate?.didFailWithErrorAnimal(error: error)
            return nil
        }
    }
    
}
