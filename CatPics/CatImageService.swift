import Foundation

class CatImageService {
    static let shared = CatImageService()
    
    private init() {}
    
    func fetchRandomCatImage() async throws -> String {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let catImages = try JSONDecoder().decode([CatImage].self, from: data)
        
        guard let firstImage = catImages.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return firstImage.url
    }
} 
