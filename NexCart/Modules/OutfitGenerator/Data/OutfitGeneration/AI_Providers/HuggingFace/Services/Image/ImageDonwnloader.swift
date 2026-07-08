//
//  ImageDonwnloader.swift
//  NexCart
//
//  Created by Mohamed Magdy on 08/07/2026.
//

import Foundation

protocol ImageDownloadServiceProtocol {
    func downloadImage(from urlString: String) async throws -> Data
}

enum ImageDownloadError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case networkError
}

final class ImageDownloadService: ImageDownloadServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw ImageDownloadError.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw ImageDownloadError.networkError
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw ImageDownloadError.requestFailed(statusCode: statusCode)
        }

        return data
    }
}


