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
            DynamicImageView(imageURL: viewModel.catImageURL, isLoading: viewModel.isLoading)
            Text(viewModel.catFact)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            if !viewModel.isLoading {
                Task {
                    await viewModel.loadRandomCat()
                }
            }
        }
        .task {
            await viewModel.loadRandomCat()
        }
    }
}

@ViewBuilder
private func DynamicImageView(imageURL: String?, isLoading: Bool) -> some View {
    if isLoading {
        ProgressView()
            .frame(maxHeight: 300)
    } else if let imageURL = imageURL, let url = URL(string: imageURL) {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxHeight: 300)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            case .failure:
                Image(systemName: "xmark.octagon")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
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
}
#Preview {
    RandomCatView()
}
