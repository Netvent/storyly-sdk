import Foundation
import StorylyPlacement
import StorylyCore

@objc public class SPPlacementProviderManager: NSObject {
    
    @objc public static let shared = SPPlacementProviderManager()
    
    private var providers: [String: SPPlacementProviderWrapper] = [:]

    private override init() {
        super.init()
    }
    
    @objc public func createProvider(id: String) -> SPPlacementProviderWrapper {
        print("[SPPlacementProviderManager] Create provider: \(id)")
        let wrapper = SPPlacementProviderWrapper(id: id)
        providers[id] = wrapper
        return wrapper
    }
    
    @objc public func getProvider(id: String) -> SPPlacementProviderWrapper? {
        return providers[id]
    }
    
    @objc public func destroyProvider(id: String) {
        print("[SPPlacementProviderManager] Destroy provider: \(id)")
        providers.removeValue(forKey: id)
    }
}

@objc public class SPPlacementProviderWrapper: NSObject {
    
    @objc public let id: String
    @objc public lazy var provider: STRPlacementDataProvider = {
        return STRPlacementDataProvider()
    }()
    
    @objc public var sendEvent: ((String, SPPlacementProviderEventType, String) -> Void)?
    
    init(id: String) {
        self.id = id
        super.init()
    }
    
    @objc public func configure(configJson: String) {
        DispatchQueue.main.async {
          guard let parsedConfig = decodeFromJson(configJson) else {
              print("[SPPlacementProviderWrapper] Failed to parse config JSON")
              return
          }
          
          self.setupProvider(config: parsedConfig)
        }
    }
    
    private func setupProvider(config: [String: Any]) {
        DispatchQueue.main.async {
            guard let token = config["token"] as? String else {
              print("[SPPlacementProviderWrapper] Token not found in config")
              return
            }
            
            print("[SPPlacementProviderWrapper] Configuring provider with token: \(token)")
            
            let placementConfig = decodeSTRPlacementConfig(config, token: token)
            
            self.provider.delegate = STRProviderDelegateImpl(wrapper: self)
            self.provider.productDelegate = STRProviderProductDelegateImpl(wrapper: self)
            self.provider.config = placementConfig
        }
    }
    
    @objc public func hydrateProducts(productsJson: String) {
        DispatchQueue.main.async {
            guard let dict = decodeFromJson(productsJson),
                  let productsArray = dict["products"] as? [[String: Any]] else {
                return
            }
            
            print("[SPPlacementProviderWrapper] hydrateProducts: \(productsJson)")
            
            let products = productsArray.compactMap { decodeSTRProductItem($0) }
            self.provider.hydrateProducts(products: products)
        }
    }
    
    @objc public func hydrateWishlist(productsJson: String) {
        DispatchQueue.main.async {
            guard let dict = decodeFromJson(productsJson),
                  let productsArray = dict["products"] as? [[String: Any]] else {
                return
            }
            
            print("[SPPlacementProviderWrapper] hydrateWishlist: \(productsJson)")
            
            let products = productsArray.compactMap { decodeSTRProductItem($0) }
            self.provider.hydrateWishlist(products: products)
        }
    }
}

// MARK: - STRDataProviderListener Implementation

private class STRProviderDelegateImpl: NSObject, STRDataProviderDelegate {
    weak var wrapper: SPPlacementProviderWrapper?
    
    init(wrapper: SPPlacementProviderWrapper) {
        self.wrapper = wrapper
    }
    
    func onLoad(data: STRDataPayload, dataSource: STRDataSource) {
        guard let wrapper = wrapper else { return }
        
        let eventData: [String: Any] = [
            "data": encodeDataPayload(data),
            "dataSource": dataSource.description
        ]
        
        if let eventJson = encodeToJson(eventData) {
            print("[SPPlacementProviderWrapper] STRDataProviderListener:onLoad: \(eventJson)")
            wrapper.sendEvent?(wrapper.id, .onLoad, eventJson)
        }
    }
    
    func onLoadFail(errorMessage: String) {
        guard let wrapper = wrapper else { return }
        
        let eventData: [String: Any] = [
            "errorMessage": errorMessage
        ]
        
        if let eventJson = encodeToJson(eventData) {
            print("[SPPlacementProviderWrapper] STRDataProviderListener:onLoadFail: \(eventJson)")
          wrapper.sendEvent?(wrapper.id, .onLoadFail, eventJson)
        }
    }
}

// MARK: - STRDataProviderProductListener Implementation

private class STRProviderProductDelegateImpl: NSObject, STRDataProviderProductDelegate {
    weak var wrapper: SPPlacementProviderWrapper?
    
    init(wrapper: SPPlacementProviderWrapper) {
        self.wrapper = wrapper
    }
    
    func onHydration(products: [STRProductInformation]) {
        guard let wrapper = wrapper else { return }
        
        let eventData: [String: Any] = [
            "products": products.map { encodeSTRProductInformation($0) }
        ]
        
        if let eventJson = encodeToJson(eventData) {
            print("[SPPlacementProviderWrapper] STRDataProviderProductListener:onHydration: \(eventJson)")
            wrapper.sendEvent?(wrapper.id, .onHydration, eventJson)
        }
    }
}

