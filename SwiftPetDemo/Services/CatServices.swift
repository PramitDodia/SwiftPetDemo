//
//  CatServices.swift
//  SwiftPetDemo
//
//  Created by Pramit D on 16/01/25.
//

import Foundation

protocol CatServiceProtocol {
    func fetchData<T: Decodable>(from urlString: String, decodeTo type: T.Type) async throws -> T
    func fetchRandomCatImage(from urlString: String) async throws -> Cat
    func fetchRandomCatFact(from urlString: String) async throws -> String
}

class CatService: CatServiceProtocol {

    func fetchData<T: Decodable>(from urlString: String, decodeTo type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    func fetchRandomCatImage(from urlString: String) async throws -> Cat {
        let cats = try await fetchData(from: urlString, decodeTo: [Cat].self)
        guard let cat = cats.first else {
            throw URLError(.cannotParseResponse)
        }
        return cat
    }
       
    func fetchRandomCatFact(from urlString: String) async throws -> String {
        struct CatFact: Decodable {
            let data: [String]
        }
        let fact = try await fetchData(from: urlString, decodeTo: CatFact.self)
        return fact.data.first ?? "No fact available"
    }

}
