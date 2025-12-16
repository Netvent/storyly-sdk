import Foundation
import StorylyPlacement
import StorylyCore

@objc public class RNPlacementProviderManager: NSObject {
    
    @objc public static let shared = RNPlacementProviderManager()
    
    private var providers: [String: RNPlacementProviderWrapper] = [:]
    private let lock = NSLock()
    
    private override init() {
        super.init()
    }
    
    @objc public func createProvider(id: String) -> RNPlacementProviderWrapper {
        lock.lock()
        defer { lock.unlock() }
        
        print("[RNPlacementProviderManager] Create provider: \(id)")
        let wrapper = RNPlacementProviderWrapper(id: id)
        providers[id] = wrapper
        return wrapper
    }
    
    @objc public func getProvider(id: String) -> RNPlacementProviderWrapper? {
        lock.lock()
        defer { lock.unlock() }
        
        return providers[id]
    }
    
    @objc public func destroyProvider(id: String) {
        lock.lock()
        defer { lock.unlock() }
        
        print("[RNPlacementProviderManager] Destroy provider: \(id)")
        providers.removeValue(forKey: id)
    }
}

@objc public class RNPlacementProviderWrapper: NSObject {
    
    @objc public let id: String
    @objc public lazy var provider: PlacementDataProvider = {
        return PlacementDataProvider()
    }()
    
    @objc public var sendEvent: ((String, RNPlacementProviderEventType, String) -> Void)?
    
    init(id: String) {
        self.id = id
        super.init()
    }
    
    @objc public func configure(configJson: String) {
        guard let parsedConfig = decodeFromJson(configJson) else {
            print("[RNPlacementProviderWrapper] Failed to parse config JSON")
            return
        }
        
        setupProvider(config: parsedConfig)
    }
    
    private func setupProvider(config: [String: Any]) {
        guard let token = config["token"] as? String else {
            print("[RNPlacementProviderWrapper] Token not found in config")
            return
        }
        
        print("[RNPlacementProviderWrapper] Configuring provider with token: \(token)")
        
        let placementConfig = decodeSTRPlacementConfig(config, token: token)
        
        provider.delegate = STRProviderListenerImpl(wrapper: self)
        provider.productDelegate = STRProviderProductListenerImpl(wrapper: self)
        provider.config = placementConfig
    }
    
    @objc public func hydrateProducts(productsJson: String) {
        guard let dict = decodeFromJson(productsJson),
              let productsArray = dict["products"] as? [[String: Any]] else {
            return
        }
        
        print("[RNPlacementProviderWrapper] hydrateProducts: \(productsJson)")
        
        let products = productsArray.compactMap { decodeSTRProductItem($0) }
        provider.hydrateProducts(products: products)
    }
    
    @objc public func hydrateWishlist(productsJson: String) {
        guard let dict = decodeFromJson(productsJson),
              let productsArray = dict["products"] as? [[String: Any]] else {
            return
        }
        
        print("[RNPlacementProviderWrapper] hydrateWishlist: \(productsJson)")
        
        let products = productsArray.compactMap { decodeSTRProductItem($0) }
        provider.hydrateWishlist(products: products)
    }
    
    @objc public func updateCart(cartJson: String) {
        guard let dict = decodeFromJson(cartJson),
              let cartDict = dict["cart"] as? [String: Any],
              let cart = decodeSTRCart(cartDict) else {
            return
        }
        
        print("[RNPlacementProviderWrapper] updateCart: \(cartJson)")
        
        provider.updateCart(cart: cart)
    }
}

// MARK: - STRProviderListener Implementation

private class STRProviderListenerImpl: NSObject, STRProviderDelegate {
    weak var wrapper: RNPlacementProviderWrapper?
    
    init(wrapper: RNPlacementProviderWrapper) {
        self.wrapper = wrapper
    }
    
    func onLoad(data: STRDataPayload, dataSource: STRDataSource) {
        guard let wrapper = wrapper else { return }
        
        let eventData: [String: Any] = [
            "data": encodeDataPayload(data),
            "dataSource": dataSource.description
        ]
        
        if let eventJson = encodeToJson(eventData) {
            print("[RNPlacementProviderWrapper] STRProviderListener:onLoad: \(eventJson)")
            wrapper.sendEvent?(wrapper.id, .onLoad, eventJson)
        }
    }
    
    func onLoadFail(errorMessage: String) {
        guard let wrapper = wrapper else { return }
        
        let eventData: [String: Any] = [
            "errorMessage": errorMessage
        ]
        
        if let eventJson = encodeToJson(eventData) {
            print("[RNPlacementProviderWrapper] STRProviderListener:onLoadFail: \(eventJson)")
          wrapper.sendEvent?(wrapper.id, .onLoadFail, eventJson)
        }
    }
}

// MARK: - STRProviderProductListener Implementation

private class STRProviderProductListenerImpl: NSObject, STRProviderProductDelegate {
    weak var wrapper: RNPlacementProviderWrapper?
    
    init(wrapper: RNPlacementProviderWrapper) {
        self.wrapper = wrapper
    }
    
    func onHydration(products: [STRProductInformation]) {
        guard let wrapper = wrapper else { return }
        
        let eventData: [String: Any] = [
            "products": products.map { encodeSTRProductInformation($0) }
        ]
        
        if let eventJson = encodeToJson(eventData) {
            print("[RNPlacementProviderWrapper] STRProviderProductListener:onHydration: \(eventJson)")
            wrapper.sendEvent?(wrapper.id, .onHydration, eventJson)
        }
    }
}

