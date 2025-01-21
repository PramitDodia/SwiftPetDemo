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
    
    private let service: CatServiceProtocol
    init(service: CatServiceProtocol = CatService()) {
        self.service = service
    }
    
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
            async let fetchedCat = service.fetchRandomCatImage(from: constant.catRandomImage)
            async let fetchedFact = service.fetchRandomCatFact(from: constant.catFacts)
            let (cat, fact) = try await (fetchedCat, fetchedFact)
            DispatchQueue.main.async {
                self.catImageURL = cat.url
                self.catFact = fact
            }
        } catch {
            DispatchQueue.main.async {
                self.catFact = "Failed to load. Please try again."
            }
        }
        // Ensure loading state is reset
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
