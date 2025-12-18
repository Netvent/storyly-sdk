import Foundation
import StorylyPlacement
import StorylyCore

// MARK: - STRProductItem Encoding/Decoding

func encodeSTRProductItem(_ item: STRProductItem) -> [String: Any] {
    let result: [String: Any] = ([
        "productId": item.productId,
        "productGroupId": item.productGroupId,
        "title": item.title,
        "url": item.url,
        "desc": item.desc,
        "price": item.price,
        "currency": item.currency,
        "salesPrice": item.salesPrice,
        "lowestPrice": item.lowestPrice,
        "imageUrls": item.imageUrls,
        "ctaText": item.ctaText,
        "variants": item.variants?.map { encodeSTRProductVariant($0) }
    ] as [String: Any?]).compactMapValues { $0 }
    return result
}

func decodeSTRProductItem(_ dict: [String: Any]) -> STRProductItem? {
    guard let productId = dict["productId"] as? String,
          let productGroupId = dict["productGroupId"] as? String,
          let title = dict["title"] as? String,
          let url = dict["url"] as? String,
          let desc = dict["desc"] as? String,
          let currency = dict["currency"] as? String,
          let price = dict["price"] as? Double else {
        return nil
    }
    
    
    let salesPrice = dict["salesPrice"] as? Double
    let imageUrls = dict["imageUrls"] as? [String]
    let ctaText = dict["ctaText"] as? String
    let variants: [STRProductVariant]? = (dict["variants"] as? [[String: Any]])?.compactMap { decodeSTRProductVariant($0) }
    let lowestPrice = dict["lowestPrice"] as? NSNumber
    
    return STRProductItem(
        productId: productId,
        productGroupId: productGroupId,
        title: title,
        url: url,
        description: desc,
        price: Float(price),
        salesPrice: salesPrice as NSNumber?,
        lowestPrice: lowestPrice,
        currency: currency,
        imageUrls: imageUrls,
        variants: variants,
        ctaText: ctaText
    )
}

// MARK: - STRProductVariant Encoding/Decoding

func encodeSTRProductVariant(_ variant: STRProductVariant) -> [String: Any] {
    let result: [String: Any] = [
        "name": variant.name,
        "value": variant.value,
        "key": variant.key
    ]
    return result
}

func decodeSTRProductVariant(_ dict: [String: Any]) -> STRProductVariant? {
    guard let name = dict["name"] as? String,
          let value = dict["value"] as? String,
          let key = dict["key"] as? String else {
        return nil
    }
    return STRProductVariant(name: name, value: value, key: key)
}

// MARK: - STRCart Encoding/Decoding

func encodeSTRCart(_ cart: STRCart?) -> [String: Any]? {
    guard let cart = cart else { return nil }
    
    let result: [String: Any] = ([
        "items": cart.items.map { encodeSTRCartItem($0) },
        "totalPrice": cart.totalPrice,
        "currency": cart.currency,
        "oldTotalPrice": cart.oldTotalPrice
    ] as [String: Any?]).compactMapValues { $0 }
    
    return result
}

func decodeSTRCart(_ dict: [String: Any]?) -> STRCart? {
    guard let dict = dict,
          let itemsArray = dict["items"] as? [[String: Any]],
          let totalPrice = dict["totalPrice"] as? Double,
          let currency = dict["currency"] as? String else {
        return nil
    }
    let oldTotalPrice = dict["oldTotalPrice"] as? Double
    return STRCart(
        items: itemsArray.compactMap { decodeSTRCartItem($0) },
        totalPrice: Float(totalPrice),
        oldTotalPrice: oldTotalPrice as NSNumber?,
        currency: currency
    )
}

// MARK: - STRCartItem Encoding/Decoding

func encodeSTRCartItem(_ item: STRCartItem?) -> [String: Any?]? {
    guard let item = item else { return nil }
    
    let result: [String: Any] = ([
        "item": encodeSTRProductItem(item.item),
        "quantity": item.quantity,
        "totalPrice": item.totalPrice,
        "oldTotalPrice": item.oldTotalPrice,
    ] as [String: Any?]).compactMapValues { $0 }
    return result
}

func decodeSTRCartItem(_ dict: [String: Any]) -> STRCartItem? {
    guard let itemDict = dict["item"] as? [String: Any],
          let item = decodeSTRProductItem(itemDict),
          let quantity = dict["quantity"] as? Int else {
        return nil
    }
    
    let totalPrice = dict["totalPrice"] as? Double
    let oldTotalPrice = dict["oldTotalPrice"] as? Double
    
    return STRCartItem(
        item: item,
        quantity: quantity,
        totalPrice: totalPrice as NSNumber?,
        oldTotalPrice: oldTotalPrice as NSNumber?
    )
}

// MARK: - STRProductInformation Encoding

func encodeSTRProductInformation(_ info: STRProductInformation) -> [String: Any?] {
    return [
        "productId": info.productId,
        "productGroupId": info.productGroupId
    ]
}

