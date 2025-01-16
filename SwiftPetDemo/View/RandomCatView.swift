//
//  RandomCatView.swift
//  SwiftPetDemo
//
//  Created by Pramit D on 16/01/25.
//

import SwiftUI

struct RandomCatView: View {
    @StateObject private var viewModel = CatViewModel()
    
    var body: some View {
        VStack {
            if let imageURL = viewModel.catImageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    case .failure:
                        Image(systemName: "xmark.octagon")
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            }
            Text(viewModel.catFact)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
        }
        .padding()
        .contentShape(Rectangle())
        
        .onTapGesture {
            Task {
                await viewModel.loadRandomCat()
            }
        }
        .task {
            await viewModel.loadRandomCat()
        }
    }
}

#Preview {
    RandomCatView()
}
