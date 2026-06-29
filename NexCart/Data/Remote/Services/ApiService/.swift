//
//  File.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//


   func request<T: Decodable, U: Encodable>(
        endPoint: EndPoint,
        body: U? = nil
    ) async throws -> T