import Foundation
protocol AnimalManagerDelegate: class {
    func didUpdateAnimal(_ animalManager: AnimalManager, animal: AnimalModel)
    func didFailWithErrorAnimal(error: Error)
}

struct AnimalManager {
    
     
    let animalUrl = "https://serene-caverns-61931.herokuapp.com/animals"
    
    weak var delegate: AnimalManagerDelegate?

    func fetchAnimal() {
        performRequest(with: animalUrl)
    }
    
    func performRequest(with animalUrl: String) {
        if let url = URL(string: animalUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithErrorAnimal(error: error!)
                    return
                }
                if let safeData = data {
                    if let animal = self.parseJSON(safeData) {
                        self.delegate?.didUpdateAnimal(self, animal: animal)
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
            
            let animal = AnimalModel(quote: quote, icon: icon)
            return animal
        } catch {
            delegate?.didFailWithErrorAnimal(error: error)
            return nil
        }
    }
    
}

