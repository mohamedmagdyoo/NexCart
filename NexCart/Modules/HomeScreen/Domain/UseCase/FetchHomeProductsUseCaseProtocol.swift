import Foundation

protocol FetchHomeProductsUseCaseProtocol {
    func execute() async throws -> [ProductEntity]
}

final class FetchHomeProductsUseCase: FetchHomeProductsUseCaseProtocol {
    private let repo: HomeRepoProtocol
    init(repo: HomeRepoProtocol = HomeRepository()) { self.repo = repo }

    func execute() async throws -> [ProductEntity] {
        try await repo.fetchProducts(limit: 6)
    }
}

protocol FetchHomeBrandsUseCaseProtocol {
    func execute() async throws -> [BrandEntity]
}

final class FetchHomeBrandsUseCase: FetchHomeBrandsUseCaseProtocol {
    private let repo: HomeRepoProtocol
    init(repo: HomeRepoProtocol = HomeRepository()) { self.repo = repo }

    func execute() async throws -> [BrandEntity] {
        var brands = try await repo.fetchBrands()
        if !brands.isEmpty { brands[0].isSelected = true }
        return brands
    }
}

protocol FetchHeroSlidesUseCaseProtocol {
    func execute() -> [HeroSlideEntity]
}

final class FetchHeroSlidesUseCase: FetchHeroSlidesUseCaseProtocol {
    
    private let staticImages = [
        "https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1200",
        "https://images.unsplash.com/photo-1479064555552-3ef4979f8908?q=80&w=1200",
        "https://images.unsplash.com/photo-1469334031218-e382a71b716b?q=80&w=1200"
    ]
    
    private let labels = [
        AppSettings.shared.loc("SS25 COLLECTION", "مجموعة صيف ٢٥"),
        AppSettings.shared.loc("EXCLUSIVE EDIT", "نسخة حصرية"),
        AppSettings.shared.loc("LIMITED EDITION", "إصدار محدود")
    ]
    private let titles = [
        AppSettings.shared.loc("The New\nArrivals", "الوصول\nالجديد"),
        AppSettings.shared.loc("Curated\nFor You", "منسق\nلك"),
        AppSettings.shared.loc("Rare\nFinds", "اكتشافات\nنادرة")
    ]
    private let subtitles = [
        AppSettings.shared.loc("Fresh drops · Free global shipping", "تشكيلة جديدة · شحن عالمي مجاني"),
        AppSettings.shared.loc("Hand-picked pieces · Express delivery", "قطع مختارة بعناية · توصيل سريع"),
        AppSettings.shared.loc("Only a few left · Shop now", "بقي القليل · تسوق الآن")
    ]

    func execute() -> [HeroSlideEntity] {
        (0..<3).map { i in
            HeroSlideEntity(
                id: "static_slide_\(i)",
                collectionLabel: labels[i],
                title: titles[i],
                subtitle: subtitles[i],
                imageURL: staticImages[i]
            )
        }
    }
}
