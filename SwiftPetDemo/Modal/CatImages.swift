//
//  CatImages.swift
//  SwiftPetDemo
//
//  Created by Pramit D on 16/01/25.
//

import Foundation

// MARK: - Model
struct Cat: Identifiable, Codable {
    let id = UUID()
    let url: String
}
