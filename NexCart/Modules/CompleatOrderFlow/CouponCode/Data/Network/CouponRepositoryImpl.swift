//
//  CouponRepositoryImpl.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


final class CouponRepositoryImpl: CouponRepository {
    private let remoteDataSource: CouponRemoteDataSource
    
    init(remoteDataSource: CouponRemoteDataSource) { self.remoteDataSource = remoteDataSource }
    
    func fetchCoupon(code: String) async throws -> CouponEntity {
        try await remoteDataSource.fetchCoupon(code: code)
    }
}
