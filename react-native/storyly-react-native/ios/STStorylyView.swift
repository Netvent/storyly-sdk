//
//  STStorylyView.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 26.10.2022.
//

import Storyly


@objc(STStorylyView)
class STStorylyView: UIView {
    @objc(storylyBundle)
    var storylyBundle: StorylyBundle? = nil {
        didSet {
            self.storylyView = self.storylyBundle?.storylyView
            self.storyGroupViewFactory = self.storylyBundle?.storyGroupViewFactory
        }
    }
    
    private var storylyView: StorylyView? = nil {
        didSet {
            print("STR:STStorylyView:storylyView:didSet:\(storylyView)")
            oldValue?.removeFromSuperview()
            guard let storylyView = storylyView else { return }
            storylyView.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
            storylyView.delegate = self
            addSubview(storylyView)
            
            storylyView.translatesAutoresizingMaskIntoConstraints = false
            storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            storylyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            storylyView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    private var storyGroupViewFactory: STStoryGroupViewFactory? = nil {
        didSet {
            guard let storyGroupViewFactory = storyGroupViewFactory else { return }
            storyGroupViewFactory.onCreateCustomView = self.onCreateCustomView
            storyGroupViewFactory.onUpdateCustomView = self.onUpdateCustomView
            self.storylyView?.storyGroupViewFactory = storyGroupViewFactory
        }
    }
    
    @objc(onStorylyLoaded)
    var onStorylyLoaded: RCTBubblingEventBlock?

    @objc(onStorylyLoadFailed)
    var onStorylyLoadFailed: RCTBubblingEventBlock?

    @objc(onStorylyEvent)
    var onStorylyEvent: RCTBubblingEventBlock?

    @objc(onStorylyActionClicked)
    var onStorylyActionClicked: RCTBubblingEventBlock?

    @objc(onStorylyStoryPresented)
    var onStorylyStoryPresented: RCTBubblingEventBlock?
    
    @objc(onStorylyStoryPresentFailed)
    var onStorylyStoryPresentFailed: RCTBubblingEventBlock?
    
    @objc(onStorylyStoryDismissed)
    var onStorylyStoryDismissed: RCTBubblingEventBlock?
    
    @objc(onStorylyUserInteracted)
    var onStorylyUserInteracted: RCTBubblingEventBlock?
    
    @objc(onCreateCustomView)
    var onCreateCustomView: RCTBubblingEventBlock?
    
    var onUpdateCustomView: RCTBubblingEventBlock? = nil {
        didSet {
            print("STR:STStorylyView:onUpdateCustomView:didSet:\(onUpdateCustomView)")
        }
    }
      
    @objc(onStorylyProductHydration)
    var onProductHydration: RCTBubblingEventBlock? = nil
     
    @objc(onStorylyProductEvent)
    var onProductEvent: RCTBubblingEventBlock? = nil

    
    @objc(storyGroupViewFactorySize)
    var storyGroupViewFactorySize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            print("STR:STStorylyView:storyGroupViewFactorySize:didSet:\(storyGroupViewFactorySize)")
            if storyGroupViewFactorySize.width <= 0 || storyGroupViewFactorySize.height <= 0 { return }
            self.storyGroupViewFactory = STStoryGroupViewFactory(width: storyGroupViewFactorySize.width,
                                                            height: storyGroupViewFactorySize.height)
            self.storyGroupViewFactory?.onCreateCustomView = self.onCreateCustomView
            self.storyGroupViewFactory?.onUpdateCustomView = self.onUpdateCustomView
            self.storylyView.storyGroupViewFactory = self.storyGroupViewFactory
        }
    }
    var storyGroupViewFactory: STStoryGroupViewFactory? = nil {
        didSet {
            print("STR:STStorylyView:storyGroupViewFactory:didSet:\(storyGroupViewFactory)")
        }
    }

    @objc(storyGroupSize)
    var storyGroupSize: NSString = "" {
        didSet {
            print("STR:STStorylyView:storyGroupSize:didSet:\(storyGroupSize)")
            DispatchQueue.main.async { [weak self] in
                self?.storylyView.storyGroupSize = (self?.storyGroupSize as? String) ?? ""
            }
        }
    }

    @objc(onUpdateCustomView)
    var onUpdateCustomView: RCTBubblingEventBlock?
    
    override init(frame: CGRect) {
        print("STR:STStorylyView:init(frame:\(frame))")
        self.storylyView = StorylyView(frame: frame)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        print("STR:STStorylyView:init:rootViewController:\(UIApplication.shared.delegate?.window??.rootViewController)")
        _ = UIApplication.shared.delegate?.window??.rootViewController?.observe(\.self,
                                                                                 options: [.initial, .old, .new]){ object, change in
            print("STR:STStorylyView:init:observe:rootViewController:newValue:\(change.newValue):oldValue:\(change.oldValue)")
        }
        
        print("STR:STStorylyView:init:StorylyBundle:\(Bundle(for: StorylyView.self).infoDictionary)")
        
        self.storylyView.delegate = self
        self.storylyView.productDelegate = self
        self.addSubview(storylyView)
        
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.storylyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.storylyView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        print("STR:STStorylyView:init(coder:\(coder))")
        fatalError("init(coder:) has not been implemented")
    }
    
    override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
        print("STR:STStorylyView:insertReactSubview(subview:\(subview):at\(atIndex))")
        guard let subview = subview as? STStorylyGroupView else { return }
        storyGroupViewFactory?.attachCustomReactNativeView(subview: subview, index: atIndex)
    }
}

extension STStorylyView {
    func refresh() {
        print("STR:STStorylyView:refresh()")
        storylyView?.refresh()
    }
    
    func open() {
        print("STR:STStorylyView:open()")
        storylyView?.present(animated: false)
        storylyView?.resume()
    }
    
    func close() {
        print("STR:STStorylyView:close()")
        storylyView?.pause()
        storylyView?.dismiss(animated: false)
    }
    
    func openStory(payload: URL) {
        print("STR:STStorylyView:openStory(payload:\(payload))")
        storylyView?.openStory(payload: payload)
    }
    
    func openStory(storyGroupId: String, storyId: String) {
        print("STR:STStorylyView:openStory(storyGroupId:\(storyGroupId):storyId:\(storyId))")
        storylyView?.openStory(storyGroupId: storyGroupId, storyId: storyId)
    }
    
    func setExternalData(externalData: [NSDictionary]) {
        print("STR:STStorylyView:openStory(externalData:\(externalData))")
        return storylyView.setExternalData(externalData: externalData)
    } 
     
    func hydrateProducts(products: [STRProductItem]){
        storylyView.hydrateProducts(products: products)
        storylyView?.setExternalData(externalData: externalData)
    }
}

extension STStorylyView: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView, storyGroupList: [StoryGroup], dataSource: StorylyDataSource) {
        let map: [String : Any] = [
            "storyGroupList": storyGroupList.map { createStoryGroupMap(storyGroup: $0) },
            "dataSource": dataSource.description
        ]
        self.onStorylyLoaded?(map)
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {
        self.onStorylyLoadFailed?(["errorMessage": errorMessage])
    }
    
    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) {
        self.onStorylyActionClicked?(createStoryMap(story: story) as [AnyHashable: Any])
    }
    
    func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
        let map: [String : Any] = [
            "event": StorylyEventHelper.storylyEventName(event: event),
            "storyGroup": createStoryGroupMap(storyGroup) as Any,
            "story": createStoryMap(story) as Any,
            "storyComponent": createStoryComponentMap(storyComponent) as Any
        ]
        self.onStorylyEvent?(map)
    }
    
    func storylyStoryPresented(_ storylyView: StorylyView) {
        self.onStorylyStoryPresented?([:])
    }
    
    func storylyStoryPresentFailed(_ storylyView: StorylyView, errorMessage: String) {
        self.onStorylyStoryPresentFailed?(["errorMessage": errorMessage])
    }
    
    func storylyStoryDismissed(_ storylyView: StorylyView) {
        self.onStorylyStoryDismissed?([:])
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {
        let map: [String : Any] = [
            "storyGroup": createStoryGroupMap(storyGroup: storyGroup),
            "story": createStoryMap(story: story),
            "storyComponent": createStoryComponentMap(storyComponent: storyComponent)
        ]
        self.onStorylyUserInteracted?(map)
    }
}
 
extension STStorylyView: StorylyProductDelegate {
    
    func storylyHydration(_ storylyView: Storyly.StorylyView, productIds: [String]) {
        let map: [String : Any] = [
            "productIds": productIds
        ]
        self.onProductHydration?(map)
    }
      
    func storylyEvent(_ storylyView: Storyly.StorylyView, event: Storyly.StorylyEvent, product: Storyly.STRProductItem?, extras: [String : String]) {
        let map: [String : Any] = [
            "event": StorylyEventHelper.storylyEventName(event: event),
            "product": createSTRProductItemMap(product: product),
            "extras": extras
        ]
        self.onProductEvent?(map)
    }
}
