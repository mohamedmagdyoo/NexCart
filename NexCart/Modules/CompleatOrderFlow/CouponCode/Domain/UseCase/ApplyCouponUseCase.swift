//
//  ApplyCouponUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


protocol ApplyCouponUseCaseProtocol {
    func execute(code: String, currentTotal: Double) async -> CouponApplicationResult
}

final class ApplyCouponUseCase: ApplyCouponUseCaseProtocol {
    private let repository: CouponRepository

    init(repository: CouponRepository) {
        self.repository = repository
    }

    func execute(code: String, currentTotal: Double) async -> CouponApplicationResult {
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCode.isEmpty else {
            return invalidResult(total: currentTotal, message: "Please enter a coupon code")
        }

        do {
            let coupon = try await repository.fetchCoupon(code: trimmedCode)
            try validate(coupon)

            let discountAmount = calculateDiscount(coupon: coupon, total: currentTotal)
            print("Discount: \(discountAmount)")
            print("Coupon value: \(coupon.value)")
            let finalTotal = max(currentTotal - discountAmount, 0)

            return CouponApplicationResult(
                originalTotal: currentTotal,
                finalTotal: finalTotal,
                isValid: true,
                discountAmount: discountAmount,
                message: "Coupon applied successfully",
                coupon: coupon
            )
        } catch {
            return invalidResult(total: currentTotal, message: message(for: error))
        }
    }

    private func validate(_ coupon: CouponEntity) throws {
        guard coupon.isActive else { throw CouponError.couponInactive }
        let now = Date()
        if let startsAt = coupon.startsAt, startsAt > now { throw CouponError.couponNotYetActive }
        if let endsAt = coupon.endsAt, endsAt < now { throw CouponError.couponExpired }
    }

    private func calculateDiscount(coupon: CouponEntity, total: Double) -> Double {
        switch coupon.discountType {
        case .percentage:
            return total * (coupon.value / 100)
        case .fixedAmount:
            return min(coupon.value, total)
        }
    }

    private func invalidResult(total: Double, message: String) -> CouponApplicationResult {
        CouponApplicationResult(originalTotal: total, finalTotal: total, isValid: false, discountAmount: 0, message: message, coupon: nil)
    }

    private func message(for error: Error) -> String {
        switch error as? CouponError {
        case .couponNotFound: return "Invalid coupon code"
        case .couponExpired: return "This coupon has expired"
        case .couponNotYetActive: return "This coupon is not active yet"
        case .couponInactive: return "This coupon is no longer active"
        case .unsupportedDiscountType: return "This coupon type isn't supported yet"
        case .network(let underlying): return underlying.localizedDescription
        default: return "Something went wrong validating the coupon"
        }
    }
}
