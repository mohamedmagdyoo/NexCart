//
//  NexCartApp.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI

@main
struct NexCartApp: App {
    let persistenceController = PersistenceController.shared
    var dummy: Product {
         Product(
             id: 1,
             title: "Gold Chain Top",
             bodyHtml: "Sculptural top with architectural 18k gold-plated chain hardware detailing at the shoulder.",
             vendor: "Jacquemus",
             productType: "Tops",
             createdAt: "2026-01-01T00:00:00Z",
             handle: "gold-chain-top",
             updatedAt: "2026-01-01T00:00:00Z",
             publishedAt: "2026-01-01T00:00:00Z",
             publishedScope: "web",
             tags: "new,featured",
             status: "active",
             variants: [
                 Variant(
                     id: 1,
                     productId: 1,
                     title: "S / Black",
                     price: "560.00",
                     position: 1,
                     inventoryPolicy: "deny",
                     compareAtPrice: "780.00",
                     option1: "S",
                     option2: "Black",
                     option3: nil,
                     createdAt: "2026-01-01T00:00:00Z",
                     updatedAt: "2026-01-01T00:00:00Z",
                     taxable: true,
                     barcode: nil,
                     fulfillmentService: "manual",
                     grams: 200,
                     inventoryManagement: "shopify",
                     requiresShipping: true,
                     sku: "GCT-S-BLK",
                     weight: 0.2,
                     weightUnit: "kg",
                     inventoryItemId: 1,
                     inventoryQuantity: 10,
                     oldInventoryQuantity: 10,
                     imageId: nil
                 ),
                 Variant(
                     id: 2,
                     productId: 1,
                     title: "M / Black",
                     price: "560.00",
                     position: 2,
                     inventoryPolicy: "deny",
                     compareAtPrice: "780.00",
                     option1: "M",
                     option2: "Black",
                     option3: nil,
                     createdAt: "2026-01-01T00:00:00Z",
                     updatedAt: "2026-01-01T00:00:00Z",
                     taxable: true,
                     barcode: nil,
                     fulfillmentService: "manual",
                     grams: 200,
                     inventoryManagement: "shopify",
                     requiresShipping: true,
                     sku: "GCT-M-BLK",
                     weight: 0.2,
                     weightUnit: "kg",
                     inventoryItemId: 2,
                     inventoryQuantity: 5,
                     oldInventoryQuantity: 5,
                     imageId: nil
                 ),
                 Variant(
                     id: 3,
                     productId: 1,
                     title: "L / Gold",
                     price: "580.00",
                     position: 3,
                     inventoryPolicy: "deny",
                     compareAtPrice: nil,
                     option1: "L",
                     option2: "Gold",
                     option3: nil,
                     createdAt: "2026-01-01T00:00:00Z",
                     updatedAt: "2026-01-01T00:00:00Z",
                     taxable: true,
                     barcode: nil,
                     fulfillmentService: "manual",
                     grams: 220,
                     inventoryManagement: "shopify",
                     requiresShipping: true,
                     sku: "GCT-L-GLD",
                     weight: 0.22,
                     weightUnit: "kg",
                     inventoryItemId: 3,
                     inventoryQuantity: 0,
                     oldInventoryQuantity: 0,
                     imageId: nil
                 )
             ],
             options: [
                 ProductOption(id: 1, productId: 1, name: "Size", position: 1, values: ["S", "M", "L"]),
                 ProductOption(id: 2, productId: 1, name: "Color", position: 2, values: ["Black", "Gold"])
             ],
             images: [
                 ProductImage(
                     id: 1,
                     alt: "Gold Chain Top front",
                     position: 1,
                     productId: 1,
                     createdAt: "2026-01-01T00:00:00Z",
                     updatedAt: "2026-01-01T00:00:00Z",
                     width: 1000,
                     height: 1200,
                     src: "https://picsum.photos/seed/goldchaintop1/1000/1200",
                     variantIds: [1, 2]
                 ),
                 ProductImage(
                     id: 2,
                     alt: "Gold Chain Top back",
                     position: 2,
                     productId: 1,
                     createdAt: "2026-01-01T00:00:00Z",
                     updatedAt: "2026-01-01T00:00:00Z",
                     width: 1000,
                     height: 1200,
                     src: "https://picsum.photos/seed/goldchaintop2/1000/1200",
                     variantIds: [3]
                 )
             ],
             image: nil
         )
     }

    //Flag For Splash Screen
    @State private var showSplash: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                OnboardingFlowView(onFinish:{})
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                //Splash Screen
                if showSplash{
                    LaunchScreen()
                }
            }// ZStack
            .task {
                try! await Task.sleep(nanoseconds: 2000000000)
                showSplash = false
            }
        }
    }
}
