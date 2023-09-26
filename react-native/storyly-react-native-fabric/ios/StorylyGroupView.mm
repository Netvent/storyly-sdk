//
//  StorylyGroupView.m
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.09.2023.
//

#import "StorylyGroupView.h"

#import <react/renderer/components/storylyfabric/ComponentDescriptors.h>
#import <react/renderer/components/storylyfabric/EventEmitters.h>
#import <react/renderer/components/storylyfabric/Props.h>
#import <react/renderer/components/storylyfabric/RCTComponentViewHelpers.h>

#import <storyly_react_native/storyly_react_native-Swift.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;


@interface StorylyGroupView () <RCTStorylyGroupViewViewProtocol>
    
@end

@implementation StorylyGroupView {
    STStorylyGroupView *_stStorylyGroupView;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<StorylyGroupViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const StorylyGroupViewProps>();
        _props = defaultProps;

        _stStorylyGroupView = [[STStorylyGroupView alloc] initWithFrame:frame];
        self.contentView = _stStorylyGroupView;
    }
    return self;
}

@end

Class<RCTComponentViewProtocol> StorylyGroupViewCls(void)
{
  return StorylyGroupView.class;
}
