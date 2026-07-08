//
//  ImageComposition.swift
//  NexCart
//
//  Created by Mohamed Magdy on 08/07/2026.
//

import Foundation


import UIKit

protocol ImageCompositionServiceProtocol {
    func composite(images: [Data]) throws -> Data
}

enum ImageCompositionError: Error {
    case noValidImages
    case renderingFailed
}

final class ImageCompositionService: ImageCompositionServiceProtocol {
    private let targetHeight: CGFloat = 512
    private let jpegQuality: CGFloat = 0.85

    func composite(images: [Data]) throws -> Data {
        let uiImages = images.compactMap { UIImage(data: $0) }
        guard !uiImages.isEmpty else {
            throw ImageCompositionError.noValidImages
        }

        if uiImages.count == 1 {
            guard let jpegData = uiImages[0].jpegData(compressionQuality: jpegQuality) else {
                throw ImageCompositionError.renderingFailed
            }
            return jpegData
        }

        let resized = uiImages.map { resize($0, toHeight: targetHeight) }
        let totalWidth = resized.reduce(0) { $0 + $1.size.width }
        let canvasSize = CGSize(width: totalWidth, height: targetHeight)

        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let compositeImage = renderer.image { _ in
            var xOffset: CGFloat = 0
            for image in resized {
                image.draw(at: CGPoint(x: xOffset, y: 0))
                xOffset += image.size.width
            }
        }

        guard let jpegData = compositeImage.jpegData(compressionQuality: jpegQuality) else {
            throw ImageCompositionError.renderingFailed
        }
        return jpegData
    }

    private func resize(_ image: UIImage, toHeight height: CGFloat) -> UIImage {
        let scale = height / image.size.height
        let newSize = CGSize(width: image.size.width * scale, height: height)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
