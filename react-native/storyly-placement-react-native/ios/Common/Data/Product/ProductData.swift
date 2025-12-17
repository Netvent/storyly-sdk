import Foundation
import StorylyPlacement
import StorylyCore

// MARK: - STRProductItem Encoding/Decoding

func encodeSTRProductItem(_ item: STRProductItem) -> [String: Any] {
    var result: [String: Any?] = [
        "productId": item.productId,
        "productGroupId": item.productGroupId,
        "title": item.title,
        "url": item.url,
        "desc": item.desc
    ]
    
    result["price"] =  item.price
    result["currency"] = item.currency
  
    if let salesPrice = item.salesPrice {
        result["salesPrice"] = salesPrice
    }
    if let lowestPrice = item.lowestPrice {
        result["lowestPrice"] = lowestPrice
    }
  
    if let imageUrls = item.imageUrls {
        result["imageUrls"] = imageUrls
    }
    if let ctaText = item.ctaText {
        result["ctaText"] = ctaText
    }
    if let variants = item.variants {
        result["variants"] = variants.map { encodeSTRProductVariant($0) }
    }
    
  return result as [String: Any?]
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
    
    var variants: [STRProductVariant]? = nil
    if let variantsArray = dict["variants"] as? [[String: Any]] {
        variants = variantsArray.compactMap { decodeSTRProductVariant($0) }
    }
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
    var result: [String: Any] = [
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
    
    var result: [String: Any] = [
        "items": cart.items.map { encodeSTRCartItem($0) },
        "totalPrice": cart.totalPrice,
        "currency": cart.currency
    ]
    
    if let oldTotalPrice = cart.oldTotalPrice {
        result["oldTotalPrice"] = oldTotalPrice
    }
    
    return result
}

func decodeSTRCart(_ dict: [String: Any]?) -> STRCart? {
    guard let dict = dict,
          let itemsArray = dict["items"] as? [[String: Any]],
          let totalPrice = dict["totalPrice"] as? Double,
          let currency = dict["currency"] as? String else {
        return nil
    }
    
    let items = itemsArray.compactMap { decodeSTRCartItem($0) }
    let oldTotalPrice = dict["oldTotalPrice"] as? Double
    
    return STRCart(
        items: items,
        totalPrice: Float(totalPrice),
        oldTotalPrice: oldTotalPrice as NSNumber?,
        currency: currency
    )
}

// MARK: - STRCartItem Encoding/Decoding

func encodeSTRCartItem(_ item: STRCartItem?) -> [String: Any]? {
    guard let item = item else { return nil }
    
    var result: [String: Any] = [
        "item": encodeSTRProductItem(item.item),
        "quantity": item.quantity
    ]
    
    if let totalPrice = item.totalPrice {
        result["totalPrice"] = totalPrice
    }
    if let oldTotalPrice = item.oldTotalPrice {
        result["oldTotalPrice"] = oldTotalPrice
    }
    
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

func encodeSTRProductInformation(_ info: STRProductInformation) -> [String: Any] {
    return [
        "productId": info.productId,
        "productGroupId": info.productGroupId
    ]
}

