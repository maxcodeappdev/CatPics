//
//  CatGlow.swift
//  CatPics
//
//  Created by Max Contreras on 2/19/25.
//

import SwiftUI

struct CatGlow: View {

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
                          ZStack {
                              // Blurred background glow
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                                  .blur(radius: 20)
                                  .opacity(0.7)
                                  .brightness(0.1)
                              
                              // Main image
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                          }
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
              
              Text("Your Magical Cat Pic!")
                  .padding()
                  .font(.title2)
                  .fontWeight(.medium)
              
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
                  Label("New Magical Cat", systemImage: "sparkles")
                      .padding(.horizontal, 20)
                      .padding(.vertical, 12)
                      .background(Color.purple.gradient)
                      .foregroundColor(.white)
                      .cornerRadius(10)
              }
              .disabled(isLoading)
              .padding(.bottom, 20)
          }
      }
      .padding()
      .task {
          await loadCatImage()
      }
  }
  
  
  func loadCatImage() async {
      do {
          imageURL = try await CatImageService.shared.fetchRandomCatImage()
      } catch {
          print("Error loading cat image: \(error)")
      }
      
      isLoading = false
  }
  
  
}

#Preview {
    CatGlow()
}


