import Foundation
import StorylyAnalytics

func decodeSTRAnalyticsConfig(_ dict: [String: Any]) -> STRAnalyticsConfig? {
    guard let token = dict["token"] as? String else { return nil }

    let builder = STRAnalyticsConfig.Builder()
    if let userId = dict["userId"] as? String {
        _ = builder.setUserId(userId: userId)
    }
    return builder.build(token: token)
}

func decodeSTRAnalyticProductEvent(_ event: String?) -> STRAnalyticProductEvent? {
    guard let event = event else { return nil }
    return STRAnalyticProductEvent(value: event)
}

func decodeSTRAnalyticProduct(_ dict: [String: Any]) -> STRAnalyticProduct? {
    guard let productId = dict["productId"] as? String,
          let productGroupId = dict["productGroupId"] as? String,
          let title = dict["title"] as? String,
          let price = dict["price"] as? Double else {
        return nil
    }

    let desc = dict["desc"] as? String
    let salesPrice = dict["salesPrice"] as? Double
    let quantity = dict["quantity"] as? Int ?? 1

    return STRAnalyticProduct(
        productId: productId,
        productGroupId: productGroupId,
        title: title,
        desc: desc,
        price: Float(price),
        salesPrice: salesPrice as NSNumber?,
        quantity: quantity
    )
}
