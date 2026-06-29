import Foundation

protocol HomeRepoProtocol {
    func fetchProducts(limit: Int) async throws -> [ProductEntity]
    func fetchAllProducts() async throws -> [ProductEntity]
    func fetchProductsByBrand(_ brand: String) async throws -> [ProductEntity]
    func fetchBrands() async throws -> [BrandEntity]
}
