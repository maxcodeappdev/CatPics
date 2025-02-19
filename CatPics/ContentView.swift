//
//  ContentView.swift
//  CatPics
//
//  Created by Max Contreras on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var imageURL: String?
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .padding()
            } else if let imageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    case .failure(_):
                        Image(systemName: "photo.fill")
                            .imageScale(.large)
                            .foregroundStyle(.red)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text("Your Cat Pic of the day!")
                .padding()
        }
        .padding()
        .task {
            await loadCatImage()
        }
    }
    
    func loadCatImage() async {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let catImages = try JSONDecoder().decode([CatImage].self, from: data)
            if let firstImage = catImages.first {
                imageURL = firstImage.url
            }
        } catch {
            print("Error loading cat image: \(error)")
        }
        
        isLoading = false
    }
}

#Preview {
    ContentView()
}


