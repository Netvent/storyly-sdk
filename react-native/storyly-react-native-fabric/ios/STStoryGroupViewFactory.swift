//
//  STStoryGroupViewFactory.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.09.2023.
//

import Storyly

internal class STStoryGroupViewFactory: StoryGroupViewFactory {
    private let width: CGFloat
    private let height: CGFloat
    
    private var customViewList: [STStoryGroupView] = []
    
    internal var onCreateCustomView: (()->Void)? = nil
    internal var onUpdateCustomView: (([String: Any])->Void)? = nil
    
    
    init(width: CGFloat,
         height: CGFloat) {
        print("STR:STStoryGroupViewFactory:init(width:\(width):height:\(height))")
        self.width = width
        self.height = height
    }
    
    func createView() -> StoryGroupView {
        print("STR:STStoryGroupViewFactory:createView()")
        let storyGroupView = STStoryGroupView(frame: .zero)
        storyGroupView.onViewUpdate = self.onUpdateView
        customViewList.append(storyGroupView)
        onCreateCustomView?()
        return storyGroupView
    }
    
    func getSize() -> CGSize {
        print("STR:STStoryGroupViewFactory:getSize()")
        return CGSize(width: width, height: height)
    }
    
    internal func attachCustomReactNativeView(subview: UIView?, index: Int) {
        print("STR:STStoryGroupViewFactory:attachCustomReactNativeView(subview:\(subview):index:\(index))")
        guard let subview = subview else { return }
        guard index < customViewList.count && index >= 0 else { return }
        
        let holderView = customViewList[index].holderView
        holderView.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leadingAnchor.constraint(equalTo: holderView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: holderView.trailingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: holderView.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: holderView.bottomAnchor).isActive = true
    }
    
    private func onUpdateView(_ groupView: STStoryGroupView, _ storyGroup: StoryGroup?) {
        print("STR:STStoryGroupViewFactory:onUpdateView(groupView:\(groupView):storyGroup:\(storyGroup))")
        guard let index = self.customViewList.firstIndex(of: groupView) else { return }
        print("STR:STStoryGroupViewFactory:onUpdateView - customViewList:\(customViewList)")
        onUpdateCustomView?([
            "index": index,
            "storyGroup": createStoryGroupMap(storyGroup) as Any
        ] as [String: Any])
        
    }
}


internal class STStoryGroupView: StoryGroupView {
    
    internal var onViewUpdate: ((STStoryGroupView, StoryGroup?) -> ())? = nil
    
    internal lazy var holderView: UIView = {
        let _holderView = UIView()
        _holderView.translatesAutoresizingMaskIntoConstraints = false
        return _holderView
    }()
    
    override init(frame: CGRect) {
        print("STR:STStoryGroupView:init(frame:\(frame))")
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("STR:STStoryGroupView:init(aDecoder:\(aDecoder))")
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.addSubview(self.holderView)
        self.holderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.holderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.holderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.holderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func populateView(storyGroup: StoryGroup?) {
        print("STR:STStoryGroupView:populateView(storyGroup:\(storyGroup))")
        onViewUpdate?(self, storyGroup)
    }
}
