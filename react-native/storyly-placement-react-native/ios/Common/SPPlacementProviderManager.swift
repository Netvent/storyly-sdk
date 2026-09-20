import Foundation
import StorylyPlacement
@_spi(InternalFramework) import StorylyCore

@objc public class SPPlacementProviderManager: NSObject {
    @objc public static let shared = SPPlacementProviderManager()
    
    private var providers: [String: SPPlacementProviderWrapper] = [:]

    private override init() {
        super.init()
    }
    
    @objc public func createProvider(id: String) -> SPPlacementProviderWrapper {
        let wrapper = SPPlacementProviderWrapper(id: id)
        providers[id] = wrapper
        return wrapper
    }
    
    @objc public func getProvider(id: String) -> SPPlacementProviderWrapper? {
        return providers[id]
    }
    
    @objc public func destroyProvider(id: String) {
        providers.removeValue(forKey: id)
    }
}

@objc public class SPPlacementProviderWrapper: NSObject {
    @objc public let id: String
    @objc public lazy var provider: STRPlacementDataProvider = {
        return STRPlacementDataProvider()
    }()
    
    @objc public var sendEvent: ((String, SPPlacementProviderEventType, String) -> Void)?
  
    private lazy var delegate = STRProviderDelegateImpl(wrapper: self)
    private lazy var productDelegate = STRProviderProductDelegateImpl(wrapper: self)
    
    init(id: String) {
        self.id = id
        super.init()
    }
    
    @objc public func configure(configJson: String) {
        DispatchQueue.main.async {
          guard let parsedConfig = decodeFromJson(configJson) else {
              STRLog.error(message: "[SPPlacementProviderWrapper] Failed to parse config JSON")
              return
          }
          
          self.setupProvider(config: parsedConfig)
        }
    }
    
    private func setupProvider(config: [String: Any]) {
        DispatchQueue.main.async {
            guard let token = config["token"] as? String else {
              STRLog.error(message: "[SPPlacementProviderWrapper] Token not found in config")
              return
            }
            
            
            let placementConfig = decodeSTRPlacementConfig(config, token: token)
            placementConfig.setFramework(framework: "rn")
            
            self.provider.delegate = self.delegate
            self.provider.productDelegate = self.productDelegate
            self.provider.config = placementConfig
        }
    }
    
    @objc public func hydrateProducts(productsJson: String) {
        DispatchQueue.main.async {
            guard let dict = decodeFromJson(productsJson),
                  let productsArray = dict["products"] as? [[String: Any]] else {
                return
            }
            
            
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
            
            
            let products = productsArray.compactMap { decodeSTRProductInformation($0) }
            self.provider.hydrateWishlist(products: products)
        }
    }
}

// MARK: - STRProviderListener Implementation

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
            wrapper.sendEvent?(wrapper.id, .onLoad, eventJson)
        }
    }
    
    func onLoadFail(errorMessage: String) {
        guard let wrapper = wrapper else { return }
        
        let eventData: [String: Any] = [
            "errorMessage": errorMessage
        ]
        
        if let eventJson = encodeToJson(eventData) {
          wrapper.sendEvent?(wrapper.id, .onLoadFail, eventJson)
        }
    }
}

// MARK: - STRProviderProductListener Implementation

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
            wrapper.sendEvent?(wrapper.id, .onHydration, eventJson)
        }
    }
}

