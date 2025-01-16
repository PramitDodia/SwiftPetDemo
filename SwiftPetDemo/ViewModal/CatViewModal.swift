//
//  CatViewModal.swift
//  SwiftPetDemo
//
//  Created by Pramit D on 16/01/25.
//

import Foundation

// MARK: - ViewModel
class CatViewModel: ObservableObject {
    @Published var catImageURL: String? = nil
    @Published var catFact: String = "Tap to load a random cat and fact!"
    @Published var isLoading: Bool = false
    
    func loadRandomCat() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        do {
            async let fetchCatImage = CatService.shared.fetchRandomCatImage(from: constant.catRandomImage)
            async let fact = CatService.shared.fetchRandomCatFact(from: constant.catFacts)
            
            let (fetchedCat, fetchedFact) = try await (fetchCatImage, fact)
            
            DispatchQueue.main.async {
                self.catImageURL = fetchedCat.url
                self.catFact = fetchedFact
            }
        } catch {
            DispatchQueue.main.async {
                self.catFact = "Failed to load. Please try again."
            }
        }
    }
}
