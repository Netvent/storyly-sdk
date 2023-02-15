//
//  STStorylyView.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 26.10.2022.
//

import Storyly


@objc(STStorylyView)
class STStorylyView: UIView {
    @objc(storylyView)
    let storylyView: StorylyView
    
    @objc(onStorylyLoaded)
    var onStorylyLoaded: RCTBubblingEventBlock? = nil
    
    @objc(onStorylyLoadFailed)
    var onStorylyLoadFailed: RCTBubblingEventBlock? = nil
    
    @objc(onStorylyEvent)
    var onStorylyEvent: RCTBubblingEventBlock? = nil
    
    @objc(onStorylyActionClicked)
    var onStorylyActionClicked: RCTBubblingEventBlock? = nil
    
    @objc(onStorylyStoryPresented)
    var onStorylyStoryPresented: RCTBubblingEventBlock? = nil
    
    @objc(onStorylyStoryPresentFailed)
    var onStorylyStoryPresentFailed: RCTBubblingEventBlock? = nil
    
    @objc(onStorylyStoryDismissed)
    var onStorylyStoryDismissed: RCTBubblingEventBlock? = nil
    
    @objc(onStorylyUserInteracted)
    var onStorylyUserInteracted: RCTBubblingEventBlock? = nil
    
    @objc(onCreateCustomView)
    var onCreateCustomView: RCTBubblingEventBlock? = nil
    
    @objc(onUpdateCustomView)
    var onUpdateCustomView: RCTBubblingEventBlock? = nil
    
    @objc(storyGroupViewFactorySize)
    var storyGroupViewFactorySize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            if storyGroupViewFactorySize.width <= 0 || storyGroupViewFactorySize.height <= 0 { return }
            self.storyGroupViewFactory = STStoryGroupViewFactory(width: storyGroupViewFactorySize.width,
                                                            height: storyGroupViewFactorySize.height)
            self.storyGroupViewFactory?.onCreateCustomView = self.onCreateCustomView
            self.storyGroupViewFactory?.onUpdateCustomView = self.onUpdateCustomView
            self.storylyView.storyGroupViewFactory = self.storyGroupViewFactory
        }
    }
    var storyGroupViewFactory: STStoryGroupViewFactory? = nil

    @objc(storyGroupSize)
    var storyGroupSize: NSString = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.storylyView.storyGroupSize = (self?.storyGroupSize as? String) ?? ""
            }
        }
    }
    
    override init(frame: CGRect) {
        self.storylyView = StorylyView(frame: frame)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.storylyView.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        self.storylyView.delegate = self
        self.addSubview(storylyView)
        
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.storylyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.storylyView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
        guard let subview = subview as? STStorylyGroupView else { return }
        storyGroupViewFactory?.attachCustomReactNativeView(subview: subview, index: atIndex)
    }
}

extension STStorylyView {
    func refresh() {
        storylyView.refresh()
    }
    
    func open() {
        storylyView.present(animated: false)
        storylyView.resume()
    }
    
    func close() {
        storylyView.pause()
        storylyView.dismiss(animated: false)
    }
    
    func openStory(payload: URL) -> Bool {
        return storylyView.openStory(payload: payload)
    }
    
    func openStory(storyGroupId: String, storyId: String) -> Bool {
        return storylyView.openStory(storyGroupId: storyGroupId, storyId: storyId)
    }
    
    func setExternalData(externalData: [NSDictionary]) -> Bool {
        return storylyView.setExternalData(externalData: externalData)
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
