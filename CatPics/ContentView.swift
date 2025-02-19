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
        ZStack {
            VStack {
                Spacer()
                
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
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    Task {
                        isLoading = true
                        await loadCatImage()
                    }
                }) {
                    Label("New Cat", systemImage: "arrow.clockwise")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isLoading)
                .padding(.bottom, 20) // Add some padding from bottom of screen
            }
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


