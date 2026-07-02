//
//  CartRepoProtcol.swift
//  NexCart
//
//  Created by Antoneos Philip on 02/07/2026.
//

import Foundation
protocol CartRepoProtcol
{

    func getAllProduct() async throws ->[BagEntity]
    
    func getSingleProduct(productId:Int) async throws ->ProductEntity
}
