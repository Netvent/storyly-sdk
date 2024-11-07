using System;
using System.Runtime.InteropServices;
using CoreGraphics;
using Foundation;
using ObjCRuntime;
using UIKit;

namespace Storyly
{
    // @interface StorylyView : UIView
    [BaseType(typeof(UIView))]
    [Protocol]
    interface StorylyView
    {
        // @property (nonatomic, strong) StorylyInit * _Nonnull storylyInit;
        [Export("storylyInit", ArgumentSemantic.Strong)]
        StorylyInit StorylyInit { get; set; }

        // @property (nonatomic, weak) UIViewController * _Nullable rootViewController;
        [NullAllowed, Export("rootViewController", ArgumentSemantic.Weak)]
        UIViewController RootViewController { get; set; }

        [Wrap("WeakDelegate")]
        [NullAllowed]
        StorylyDelegate Delegate { get; set; }

        // @property (nonatomic, weak) id<StorylyDelegate> _Nullable delegate;
        [NullAllowed, Export("delegate", ArgumentSemantic.Weak)]
        NSObject WeakDelegate { get; set; }

        [Wrap("WeakProductDelegate")]
        [NullAllowed]
        StorylyProductDelegate ProductDelegate { get; set; }

        // @property (nonatomic, weak) id<StorylyProductDelegate> _Nullable productDelegate;
        [NullAllowed, Export("productDelegate", ArgumentSemantic.Weak)]
        NSObject WeakProductDelegate { get; set; }

        // -(BOOL)openStoryWithPayload:(NSURL * _Nonnull)payload __attribute__((warn_unused_result("")));
        [Export("openStoryWithPayload:")]
        bool OpenStoryWithPayload(NSUrl payload);

        // -(void)resumeStoryWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
        [Export("resumeStoryWithAnimated:completion:")]
        void ResumeStoryWithAnimated(bool animated, [NullAllowed] Action completion);

        // -(void)pauseStoryWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
        [Export("pauseStoryWithAnimated:completion:")]
        void PauseStoryWithAnimated(bool animated, [NullAllowed] Action completion);

        // -(void)closeStoryWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
        [Export("closeStoryWithAnimated:completion:")]
        void CloseStoryWithAnimated(bool animated, [NullAllowed] Action completion);

        // -(void)hydrateProductsWithProducts:(NSArray<STRProductItem *> * _Nonnull)products;
        [Export("hydrateProductsWithProducts:")]
        void HydrateProduct(STRProductItem[] products);

        // -(void)updateCartWithCart:(STRCart * _Nonnull)cart;
        [Export("updateCartWithCart:")]
        void UpdateCart(STRCart cart);

        // -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
        [Export("initWithFrame:")]
        [DesignatedInitializer]
        IntPtr Constructor(CGRect frame);
    }
}

namespace Storyly
{
    // @protocol StorylyDelegate
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
    interface StorylyDelegate
    {
        // @optional -(void)storylyLoaded:(StorylyView * _Nonnull)storylyView storyGroupList:(NSArray<StoryGroup *> * _Nonnull)storyGroupList dataSource:(enum StorylyDataSource)dataSource;
        [Export("storylyLoaded:storyGroupList:dataSource:")]
        void StorylyLoaded(StorylyView storylyView, StoryGroup[] storyGroupList, StorylyDataSource dataSource);

        // @optional -(void)storylyLoadFailed:(StorylyView * _Nonnull)storylyView errorMessage:(NSString * _Nonnull)errorMessage;
        [Export("storylyLoadFailed:errorMessage:")]
        void StorylyLoadFailed(StorylyView storylyView, string errorMessage);

        // @optional -(void)storylyActionClicked:(StorylyView * _Nonnull)storylyView rootViewController:(UIViewController * _Nonnull)rootViewController story:(Story * _Nonnull)story;
        [Export("storylyActionClicked:rootViewController:story:")]
        void StorylyActionClicked(StorylyView storylyView, UIViewController rootViewController, Story story);

        // @optional -(void)storylyStoryPresented:(StorylyView * _Nonnull)storylyView;
        [Export("storylyStoryPresented:")]
        void StorylyStoryPresented(StorylyView storylyView);

        // @optional -(void)storylyStoryPresentFailed:(StorylyView * _Nonnull)storylyView errorMessage:(NSString * _Nonnull)errorMessage;
        [Export("storylyStoryPresentFailed:errorMessage:")]
        void StorylyStoryPresentFailed(StorylyView storylyView, string errorMessage);

        // @optional -(void)storylyStoryDismissed:(StorylyView * _Nonnull)storylyView;
        [Export("storylyStoryDismissed:")]
        void StorylyStoryDismissed(StorylyView storylyView);

        // @optional -(void)storylyUserInteracted:(StorylyView * _Nonnull)storylyView storyGroup:(StoryGroup * _Nonnull)storyGroup story:(Story * _Nonnull)story storyComponent:(StoryComponent * _Nonnull)storyComponent;
        [Export("storylyUserInteracted:storyGroup:story:storyComponent:")]
        void StorylyUserInteracted(StorylyView storylyView, StoryGroup storyGroup, Story story, StoryComponent storyComponent);

        // @optional -(void)storylyEvent:(StorylyView * _Nonnull)storylyView event:(enum StorylyEvent)event storyGroup:(StoryGroup * _Nullable)storyGroup story:(Story * _Nullable)story storyComponent:(StoryComponent * _Nullable)storyComponent;
        [Export("storylyEvent:event:storyGroup:story:storyComponent:")]
        void StorylyEvent(StorylyView storylyView, StorylyEvent @event, [NullAllowed] StoryGroup storyGroup, [NullAllowed] Story story, [NullAllowed] StoryComponent storyComponent);

		// @optional -(void)storylySizeChanged:(StorylyView * _Nonnull)storylyView size:(CGSize)size;
		[Export ("storylySizeChanged:size:")]
		void StorylySizeChanged (StorylyView storylyView, CGSize size);
    }

    // @protocol StorylyProductDelegate
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
    interface StorylyProductDelegate
    {
        // @optional -(void)storylyHydration:(StorylyView * _Nonnull)storylyView products:(NSArray<STRProductInformation *> * _Nonnull)products;
        [Export("storylyHydration:products:")]
        void StorylyHydration(StorylyView storylyView, STRProductInformation[] products);

        // @optional -(void)storylyEvent:(StorylyView * _Nonnull)storylyView event:(enum StorylyEvent)event;
        [Export("storylyEvent:event:")]
        void StorylyEvent(StorylyView storylyView, StorylyEvent @event);

        // @optional -(void)storylyUpdateCartEventWithStorylyView:(StorylyView * _Nonnull)storylyView event:(enum StorylyEvent)event cart:(STRCart * _Nullable)cart change:(STRCartItem * _Nullable)change onSuccess:(void (^ _Nullable)(STRCart * _Nullable))onSuccess onFail:(void (^ _Nullable)(STRCartEventResult * _Nonnull))onFail;
        [Export("storylyUpdateCartEventWithStorylyView:event:cart:change:onSuccess:onFail:")]
        void StorylyUpdateCartEvent(StorylyView storylyView, StorylyEvent @event, [NullAllowed] STRCart cart, [NullAllowed] STRCartItem change, [NullAllowed] Action<STRCart> onSuccess, [NullAllowed] Action<STRCartEventResult> onFail);
    }

    // @interface StoryGroup : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StoryGroup
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull uniqueId;
        [Export("uniqueId")]
        string UniqueId { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull title;
        [Export("title")]
        string Title { get; }

        // @property (readonly, copy, nonatomic) NSURL * _Nullable iconUrl;
        [NullAllowed, Export("iconUrl", ArgumentSemantic.Copy)]
        NSUrl IconUrl { get; }

        // @property (readonly, nonatomic) NSInteger index;
        [Export("index")]
        nint Index { get; }

        // @property (readonly, nonatomic) BOOL seen;
        [Export("seen")]
        bool Seen { get; }

        // @property (readonly, copy, nonatomic) NSArray<Story *> * _Nonnull stories;
        [Export("stories", ArgumentSemantic.Copy)]
        Story[] Stories { get; }

        // @property (readonly, nonatomic) BOOL pinned;
        [Export("pinned")]
        bool Pinned { get; }

        // @property (readonly, nonatomic) enum StoryGroupType type;
        [Export("type")]
        StoryGroupType Type { get; }

        // @property (readonly, nonatomic, strong) StoryGroupStyle * _Nullable style;
        [NullAllowed, Export("style", ArgumentSemantic.Strong)]
        StoryGroupStyle Style { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable name;
        [NullAllowed, Export("name")]
        string Name { get; }

        // @property (readonly, nonatomic) BOOL nudge;
        [Export("nudge")]
        bool Nudge { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title iconUrl:(NSURL * _Nullable)iconUrl index:(NSInteger)index seen:(BOOL)seen stories:(NSArray<Story *> * _Nonnull)stories pinned:(BOOL)pinned type:(enum StoryGroupType)type style:(StoryGroupStyle * _Nullable)style name:(NSString * _Nullable)name nudge:(BOOL)nudge __attribute__((objc_designated_initializer));
        [Export("initWithId:title:iconUrl:index:seen:stories:pinned:type:style:name:nudge:")]
        [DesignatedInitializer]
        IntPtr Constructor(string id, string title, [NullAllowed] NSUrl iconUrl, nint index, bool seen, Story[] stories, bool pinned, StoryGroupType type, [NullAllowed] StoryGroupStyle style, [NullAllowed] string name, bool nudge);
    }

    // @interface StoryGroupStyle : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StoryGroupStyle
    {
        // @property (readonly, copy, nonatomic) NSArray<UIColor *> * _Nullable borderUnseenColors;
        [NullAllowed, Export("borderUnseenColors", ArgumentSemantic.Copy)]
        UIColor[] BorderUnseenColors { get; }

        // @property (readonly, nonatomic, strong) UIColor * _Nullable textUnseenColor;
        [NullAllowed, Export("textUnseenColor", ArgumentSemantic.Strong)]
        UIColor TextUnseenColor { get; }

        // @property (readonly, nonatomic, strong) StoryGroupBadgeStyle * _Nullable badge;
        [NullAllowed, Export("badge", ArgumentSemantic.Strong)]
        StoryGroupBadgeStyle Badge { get; }
    }

    // @interface StoryGroupBadgeStyle : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StoryGroupBadgeStyle
    {
        // @property (readonly, copy, nonatomic) NSString * _Nullable text;
        [NullAllowed, Export("text")]
        string Text { get; }

        // @property (readonly, nonatomic, strong) UIColor * _Nullable textColor;
        [NullAllowed, Export("textColor", ArgumentSemantic.Strong)]
        UIColor TextColor { get; }

        // @property (readonly, nonatomic, strong) UIColor * _Nullable backgroundColor;
        [NullAllowed, Export("backgroundColor", ArgumentSemantic.Strong)]
        UIColor BackgroundColor { get; }
    }

    // @interface Story : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface Story
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull uniqueId;
        [Export("uniqueId")]
        string UniqueId { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull title;
        [Export("title")]
        string Title { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable name;
        [NullAllowed, Export("name")]
        string Name { get; }

        // @property (readonly, nonatomic) NSInteger index;
        [Export("index")]
        nint Index { get; }

        // @property (readonly, nonatomic) BOOL seen;
        [Export("seen")]
        bool Seen { get; }

        // @property (readonly, nonatomic) NSInteger currentTime;
        [Export("currentTime")]
        nint CurrentTime { get; }

        // @property (copy, nonatomic) NSURL * _Nullable previewUrl;
        [NullAllowed, Export("previewUrl", ArgumentSemantic.Copy)]
        NSUrl PreviewUrl { get; set; }

        // @property (readonly, copy, nonatomic) NSArray<StoryComponent *> * _Nullable storyComponentList;
        [NullAllowed, Export("storyComponentList", ArgumentSemantic.Copy)]
        StoryComponent[] StoryComponentList { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
        [NullAllowed, Export("actionUrl")]
        string ActionUrl { get; }

        // @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
        [NullAllowed, Export("products", ArgumentSemantic.Copy)]
        STRProductItem[] Products { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id index:(NSInteger)index title:(NSString * _Nonnull)title name:(NSString * _Nullable)name seen:(BOOL)seen currentTime:(NSInteger)currentTime previewUrl:(NSURL * _Nullable)previewUrl storyComponentList:(NSArray<StoryComponent *> * _Nullable)storyComponentList actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products __attribute__((objc_designated_initializer));
        [Export("initWithId:index:title:name:seen:currentTime:previewUrl:storyComponentList:actionUrl:products:")]
        [DesignatedInitializer]
        IntPtr Constructor(string id, nint index, string title, [NullAllowed] string name, bool seen, nint currentTime, [NullAllowed] NSUrl previewUrl, [NullAllowed] StoryComponent[] storyComponentList, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products);
    }

    // @interface StoryComponent : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StoryComponent
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull id;
        [Export("id")]
        string Id { get; }

        // @property (readonly, nonatomic) enum StoryComponentType type;
        [Export("type")]
        StoryComponentType Type { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable customPayload;
		[NullAllowed, Export ("customPayload")]
		string CustomPayload { get; }
    }

    // @interface StoryButtonComponent : StoryComponent
	[BaseType (typeof(StoryComponent))]
	interface StoryButtonComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:text:actionUrl:products:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string text, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
	}

    // @interface StoryCommentComponent : StoryComponent
    [BaseType(typeof(StoryComponent))]
    interface StoryCommentComponent
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull text;
        [Export("text")]
        string Text { get; }
    }

    // @interface StoryEmojiComponent : StoryComponent
    [BaseType(typeof(StoryComponent))]
    interface StoryEmojiComponent
    {
        // @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull emojiCodes;
        [Export("emojiCodes", ArgumentSemantic.Copy)]
        string[] EmojiCodes { get; }

        // @property (readonly, nonatomic) NSInteger selectedEmojiIndex;
        [Export("selectedEmojiIndex")]
        nint SelectedEmojiIndex { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id emojiCodes:(NSArray<NSString *> * _Nonnull)emojiCodes selectedEmojiIndex:(NSInteger)selectedEmojiIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:emojiCodes:selectedEmojiIndex:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string[] emojiCodes, nint selectedEmojiIndex, [NullAllowed] string customPayload);
    }

    [BaseType(typeof(UIView))]
    [Protocol]
    interface StoryGroupView
    {
        // -(void)populateView:(StoryGroup * _Nullable)storyGroup;
        [Export("populateView:")]
        void PopulateView([NullAllowed] StoryGroup storyGroup);

        // -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
        [Export("initWithFrame:")]
        [DesignatedInitializer]
        IntPtr Constructor(CGRect frame);
    }

    // @protocol StoryGroupViewFactory
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
    interface StoryGroupViewFactory
    {
        // @required -(StoryGroupView * _Nonnull)createView __attribute__((warn_unused_result("")));
        [Abstract]
        [Export("createView")]
        StoryGroupView CreateView { get; }

        // @required -(CGSize)getSize __attribute__((warn_unused_result("")));
        [Abstract]
        [Export("getSize")]
        CGSize GetSize { get; }
    }

    // @protocol XamarinStoryGroup
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
    interface XamarinStoryGroup
    {
        // @required -(UIView * _Nonnull)createView __attribute__((warn_unused_result("")));
        [Abstract]
        [Export("createView")]
        UIView CreateView { get; }

        // @required -(void)populateView:(StoryGroup * _Nullable)storyGroup;
        [Abstract]
        [Export("populateView:")]
        void PopulateView([NullAllowed] StoryGroup storyGroup);
    }

    // @interface XamarinStoryGroupView : StoryGroupView
    [BaseType(typeof(StoryGroupView))]
    interface XamarinStoryGroupView
    {
        // -(instancetype _Nonnull)initWithXamarinStoryGroup:(id<XamarinStoryGroup> _Nullable)xamarinStoryGroup __attribute__((objc_designated_initializer));
        [Export("initWithXamarinStoryGroup:")]
        [DesignatedInitializer]
        IntPtr Constructor([NullAllowed] XamarinStoryGroup xamarinStoryGroup);

        // -(void)populateView:(StoryGroup * _Nullable)storyGroup;
        [Export("populateView:")]
        void PopulateView([NullAllowed] StoryGroup storyGroup);
    }

    // @interface StoryImageQuizComponent : StoryComponent
    [BaseType(typeof(StoryComponent))]
    interface StoryImageQuizComponent
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull title;
        [Export("title")]
        string Title { get; }

        // @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nullable options;
        [NullAllowed, Export("options", ArgumentSemantic.Copy)]
        string[] Options { get; }

        // @property (readonly, nonatomic, strong) NSNumber * _Nullable rightAnswerIndex;
        [NullAllowed, Export("rightAnswerIndex", ArgumentSemantic.Strong)]
        NSNumber RightAnswerIndex { get; }

        // @property (readonly, nonatomic) NSInteger selectedOptionIndex;
        [Export("selectedOptionIndex")]
        nint SelectedOptionIndex { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nullable)options rightAnswerIndex:(NSNumber * _Nullable)rightAnswerIndex selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:title:options:rightAnswerIndex:selectedOptionIndex:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string title, [NullAllowed] string[] options, [NullAllowed] NSNumber rightAnswerIndex, nint selectedOptionIndex, [NullAllowed] string customPayload);
    }

    // @interface StoryPollComponent : StoryComponent
    [BaseType(typeof(StoryComponent))]
    interface StoryPollComponent
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull title;
        [Export("title")]
        string Title { get; }

        // @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull options;
        [Export("options", ArgumentSemantic.Copy)]
        string[] Options { get; }

        // @property (readonly, nonatomic) NSInteger selectedOptionIndex;
        [Export("selectedOptionIndex")]
        nint SelectedOptionIndex { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nonnull)options selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:title:options:selectedOptionIndex:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string title, string[] options, nint selectedOptionIndex, [NullAllowed] string customPayload);
    }

    // @interface StoryProductCardComponent : StoryComponent
	[BaseType (typeof(StoryComponent))]
	interface StoryProductCardComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:text:actionUrl:products:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string text, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
	}

    // @interface StoryProductCatalogComponent : StoryComponent
	[BaseType (typeof(StoryComponent))]
	interface StoryProductCatalogComponent
	{
		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nullable actionUrlList;
		[NullAllowed, Export ("actionUrlList", ArgumentSemantic.Copy)]
		string[] ActionUrlList { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id actionUrlList:(NSArray<NSString *> * _Nullable)actionUrlList products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:actionUrlList:products:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, [NullAllowed] string[] actionUrlList, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
	}

    // @interface StoryProductTagComponent : StoryComponent
	[BaseType (typeof(StoryComponent))]
	interface StoryProductTagComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:actionUrl:products:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
	}

    // @interface StoryPromoCodeComponent : StoryComponent
    [BaseType(typeof(StoryComponent))]
    interface StoryPromoCodeComponent
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull text;
        [Export("text")]
        string Text { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:text:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string text, [NullAllowed] string customPayload);
    }

    // @interface StoryQuizComponent : StoryComponent
    [BaseType(typeof(StoryComponent))]
    interface StoryQuizComponent
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull title;
        [Export("title")]
        string Title { get; }

        // @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull options;
        [Export("options", ArgumentSemantic.Copy)]
        string[] Options { get; }

        // @property (readonly, nonatomic, strong) NSNumber * _Nullable rightAnswerIndex;
        [NullAllowed, Export("rightAnswerIndex", ArgumentSemantic.Strong)]
        NSNumber RightAnswerIndex { get; }

        // @property (readonly, nonatomic) NSInteger selectedOptionIndex;
        [Export("selectedOptionIndex")]
        nint SelectedOptionIndex { get; }
        
        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nonnull)options rightAnswerIndex:(NSNumber * _Nullable)rightAnswerIndex selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:title:options:rightAnswerIndex:selectedOptionIndex:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string title, string[] options, [NullAllowed] NSNumber rightAnswerIndex, nint selectedOptionIndex, [NullAllowed] string customPayload);
    }

    // @interface StoryRatingComponent : StoryComponent
    [BaseType(typeof(StoryComponent))]
    interface StoryRatingComponent
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull emojiCode;
        [Export("emojiCode")]
        string EmojiCode { get; }

        // @property (readonly, nonatomic) NSInteger rating;
        [Export("rating")]
        nint Rating { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id emojiCode:(NSString * _Nonnull)emojiCode rating:(NSInteger)rating customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:emojiCode:rating:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string emojiCode, nint rating, [NullAllowed] string customPayload);
    }

    // @interface StorySwipeComponent : StoryComponent
	[BaseType (typeof(StoryComponent))]
	interface StorySwipeComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export ("initWithId:text:actionUrl:products:customPayload:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string text, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
	}

    // @interface STRCart : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRCart
    {
        // @property (readonly, copy, nonatomic) NSArray<STRCartItem *> * _Nonnull items;
        [Export("items", ArgumentSemantic.Copy)]
        STRCartItem[] Items { get; }

        // @property (readonly, nonatomic) float totalPrice;
        [Export("totalPrice")]
        float TotalPrice { get; }

        // @property (readonly, nonatomic, strong) NSNumber * _Nullable oldTotalPrice;
        [NullAllowed, Export("oldTotalPrice", ArgumentSemantic.Strong)]
        NSNumber OldTotalPrice { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull currency;
        [Export("currency")]
        string Currency { get; }

        // -(instancetype _Nonnull)initWithItems:(NSArray<STRCartItem *> * _Nonnull)items totalPrice:(float)totalPrice oldTotalPrice:(NSNumber * _Nullable)oldTotalPrice currency:(NSString * _Nonnull)currency __attribute__((objc_designated_initializer));
        [Export("initWithItems:totalPrice:oldTotalPrice:currency:")]
        [DesignatedInitializer]
        IntPtr Constructor(STRCartItem[] items, float totalPrice, [NullAllowed] NSNumber oldTotalPrice, string currency);
    }

    // @interface STRCartEventResult : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRCartEventResult
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull message;
        [Export("message")]
        string Message { get; }

        // -(instancetype _Nonnull)initWithMessage:(NSString * _Nonnull)message __attribute__((objc_designated_initializer));
        [Export("initWithMessage:")]
        [DesignatedInitializer]
        IntPtr Constructor(string message);
    }

    // @interface STRCartItem : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRCartItem
    {
        // @property (readonly, nonatomic, strong) STRProductItem * _Nonnull item;
        [Export("item", ArgumentSemantic.Strong)]
        STRProductItem Item { get; }

        // @property (readonly, nonatomic) NSInteger quantity;
        [Export("quantity")]
        nint Quantity { get; }

        // @property (readonly, nonatomic, strong) NSNumber * _Nullable totalPrice;
        [NullAllowed, Export("totalPrice", ArgumentSemantic.Strong)]
        NSNumber TotalPrice { get; }

        // @property (readonly, nonatomic, strong) NSNumber * _Nullable oldTotalPrice;
        [NullAllowed, Export("oldTotalPrice", ArgumentSemantic.Strong)]
        NSNumber OldTotalPrice { get; }

        // -(instancetype _Nonnull)initWithItem:(STRProductItem * _Nonnull)item quantity:(NSInteger)quantity totalPrice:(NSNumber * _Nullable)totalPrice oldTotalPrice:(NSNumber * _Nullable)oldTotalPrice __attribute__((objc_designated_initializer));
        [Export("initWithItem:quantity:totalPrice:oldTotalPrice:")]
        [DesignatedInitializer]
        IntPtr Constructor(STRProductItem item, nint quantity, [NullAllowed] NSNumber totalPrice, [NullAllowed] NSNumber oldTotalPrice);
    }

    // @interface STRProductInformation : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRProductInformation
    {
        // @property (readonly, copy, nonatomic) NSString * _Nullable productId;
        [NullAllowed, Export("productId")]
        string ProductId { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable productGroupId;
        [NullAllowed, Export("productGroupId")]
        string ProductGroupId { get; }

        // -(instancetype _Nonnull)initWithProductId:(NSString * _Nullable)productId productGroupId:(NSString * _Nullable)productGroupId __attribute__((objc_designated_initializer));
        [Export("initWithProductId:productGroupId:")]
        [DesignatedInitializer]
        IntPtr Constructor([NullAllowed] string productId, [NullAllowed] string productGroupId);
    }

    // @interface STRProductItem : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRProductItem : INativeObject
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull productId;
        [Export("productId")]
        string ProductId { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull productGroupId;
        [Export("productGroupId")]
        string ProductGroupId { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull title;
        [Export("title")]
        string Title { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull url;
        [Export("url")]
        string Url { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable desc;
        [NullAllowed, Export("desc")]
        string Desc { get; }

        // @property (readonly, nonatomic) float price;
        [Export("price")]
        float Price { get; }

        // @property (readonly, nonatomic, strong) NSNumber * _Nullable salesPrice;
        [NullAllowed, Export("salesPrice", ArgumentSemantic.Strong)]
        NSNumber SalesPrice { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull currency;
        [Export("currency")]
        string Currency { get; }

        // @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nullable imageUrls;
        [NullAllowed, Export("imageUrls", ArgumentSemantic.Copy)]
        string[] ImageUrls { get; }

        // @property (readonly, copy, nonatomic) NSArray<STRProductVariant *> * _Nullable variants;
        [NullAllowed, Export("variants", ArgumentSemantic.Copy)]
        STRProductVariant[] Variants { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable ctaText;
        [NullAllowed, Export("ctaText")]
        string CtaText { get; }

        // -(instancetype _Nonnull)initWithProductId:(NSString * _Nonnull)productId productGroupId:(NSString * _Nonnull)productGroupId title:(NSString * _Nonnull)title url:(NSString * _Nonnull)url description:(NSString * _Nullable)description price:(float)price salesPrice:(NSNumber * _Nullable)salesPrice currency:(NSString * _Nonnull)currency imageUrls:(NSArray<NSString *> * _Nullable)imageUrls variants:(NSArray<STRProductVariant *> * _Nullable)variants ctaText:(NSString * _Nullable)ctaText __attribute__((objc_designated_initializer));
        [Export("initWithProductId:productGroupId:title:url:description:price:salesPrice:currency:imageUrls:variants:ctaText:")]
        [DesignatedInitializer]
        IntPtr Constructor(string productId, string productGroupId, string title, string url, [NullAllowed] string description, float price, [NullAllowed] NSNumber salesPrice, string currency, [NullAllowed] string[] imageUrls, [NullAllowed] STRProductVariant[] variants, [NullAllowed] string ctaText);
    }

    // @interface STRProductVariant : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface STRProductVariant
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull name;
		[Export ("name")]
		string Name { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull value;
		[Export ("value")]
		string Value { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull key;
		[Export ("key")]
		string Key { get; }

		// -(instancetype _Nonnull)initWithName:(NSString * _Nonnull)name value:(NSString * _Nonnull)value key:(NSString * _Nonnull)key __attribute__((objc_designated_initializer));
		[Export ("initWithName:value:key:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string name, string value, string key);

		// -(BOOL)isEqual:(id _Nullable)object __attribute__((warn_unused_result("")));
		[Export ("isEqual:")]
		bool IsEqual ([NullAllowed] NSObject @object);

		// @property (readonly, nonatomic) NSUInteger hash;
		[Export ("hash")]
		nuint Hash { get; }
	}

    // @protocol StoryPriceFormatter
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
    interface StoryPriceFormatter
    {
        // -(BOOL)isEqual:(id _Nullable)object __attribute__((warn_unused_result("")));
        [Export("format::")]
        string Format([NullAllowed] NSNumber price, string currency);
    }

}


namespace Storyly
{
    // @interface StorylyInit : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StorylyInit
    {
        // @property (readonly, nonatomic, strong) StorylyConfig * _Nonnull config;
        [Export("config", ArgumentSemantic.Strong)]
        StorylyConfig Config { get; }

        // -(instancetype _Nonnull)initWithStorylyId:(NSString * _Nonnull)storylyId config:(StorylyConfig * _Nonnull)config __attribute__((objc_designated_initializer));
        [Export("initWithStorylyId:config:")]
        [DesignatedInitializer]
        IntPtr Constructor(string storylyId, StorylyConfig config);
    }

    // @interface StorylyConfig : STRConfig
    [BaseType(typeof(STRConfig))]
    interface StorylyConfig
    {
    }

    // @interface StorylyBuilder : Builder
    [BaseType(typeof(STRConfigBuilder))]
    interface StorylyBuilder
    {
        // -(instancetype _Nonnull)setStoryStyling:(StorylyStoryStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
        [Export("setStoryStyling:")]
        StorylyBuilder SetStoryStyling(StorylyStoryStyling styling);

        // -(instancetype _Nonnull)setBarStyling:(StorylyBarStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
        [Export("setBarStyling:")]
        StorylyBuilder SetBarStyling(StorylyBarStyling styling);

        // -(instancetype _Nonnull)setStoryGroupStyling:(StorylyStoryGroupStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
        [Export("setStoryGroupStyling:")]
        StorylyBuilder SetStoryGroupStyling(StorylyStoryGroupStyling styling);

        // -(StorylyConfig * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyConfig Build();
    }

    // @interface StorylyBarStyling : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StorylyBarStyling
    {
    }

    // @interface StorylyBarStylingBuilder : NSObject
    [BaseType(typeof(NSObject))]
    interface StorylyBarStylingBuilder
    {
        // -(StorylyBarStylingBuilder * _Nonnull)setOrientation:(enum StoryGroupListOrientation)orientation __attribute__((warn_unused_result("")));
        [Export("setOrientation:")]
        StorylyBarStylingBuilder SetOrientation(StoryGroupListOrientation orientation);

        // -(StorylyBarStylingBuilder * _Nonnull)setSection:(NSInteger)count __attribute__((warn_unused_result("")));
        [Export("setSection:")]
        StorylyBarStylingBuilder SetSection(nint count);

        // -(StorylyBarStylingBuilder * _Nonnull)setHorizontalEdgePadding:(CGFloat)padding __attribute__((warn_unused_result("")));
        [Export("setHorizontalEdgePadding:")]
        StorylyBarStylingBuilder SetHorizontalEdgePadding(nfloat padding);

        // -(StorylyBarStylingBuilder * _Nonnull)setVerticalEdgePadding:(CGFloat)padding __attribute__((warn_unused_result("")));
        [Export("setVerticalEdgePadding:")]
        StorylyBarStylingBuilder SetVerticalEdgePadding(nfloat padding);

        // -(StorylyBarStylingBuilder * _Nonnull)setHorizontalPaddingBetweenItems:(CGFloat)padding __attribute__((warn_unused_result("")));
        [Export("setHorizontalPaddingBetweenItems:")]
        StorylyBarStylingBuilder SetHorizontalPaddingBetweenItems(nfloat padding);

        // -(StorylyBarStylingBuilder * _Nonnull)setVerticalPaddingBetweenItems:(CGFloat)padding __attribute__((warn_unused_result("")));
        [Export("setVerticalPaddingBetweenItems:")]
        StorylyBarStylingBuilder SetVerticalPaddingBetweenItems(nfloat padding);

        // -(StorylyBarStyling * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyBarStyling Build();
    }

    // @interface StorylyStoryStyling : STRStoryStyling
    [BaseType(typeof(STRStoryStyling))]
    interface StorylyStoryStyling
    {
    }

    // @interface StorylyStoryBuilder : STRStoryBuilder
    [BaseType(typeof(STRStoryBuilder))]
    interface StorylyStoryBuilder
    {
        // -(StorylyStoryBuilder * _Nonnull)setHeaderIconBorderColor:(NSArray<UIColor *> * _Nonnull)colors __attribute__((warn_unused_result("")));
        [Export("setHeaderIconBorderColor:")]
        StorylyStoryBuilder SetHeaderIconBorderColor(UIColor[] colors);

        // -(StorylyStoryBuilder * _Nonnull)setTitleColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
        [Export("setTitleColor:")]
        StorylyStoryBuilder SetTitleColor(UIColor color);

        // -(StorylyStoryBuilder * _Nonnull)setHeaderIconVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
        [Export("setHeaderIconVisibility:")]
        StorylyStoryBuilder SetHeaderIconVisibility(bool isVisible);

        // -(StorylyStoryStyling * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyStoryStyling Build();
    }

    // @interface StorylyStoryGroupStyling : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StorylyStoryGroupStyling
    {
    }

    // @interface StorylyStoryGroupStylingBuilder : NSObject
    [BaseType(typeof(NSObject))]
    interface StorylyStoryGroupStylingBuilder
    {
        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconBorderColorSeen:(NSArray<UIColor *> * _Nonnull)colors __attribute__((warn_unused_result("")));
        [Export("setIconBorderColorSeen:")]
        StorylyStoryGroupStylingBuilder SetIconBorderColorSeen(UIColor[] colors);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconBorderColorNotSeen:(NSArray<UIColor *> * _Nonnull)colors __attribute__((warn_unused_result("")));
        [Export("setIconBorderColorNotSeen:")]
        StorylyStoryGroupStylingBuilder SetIconBorderColorNotSeen(UIColor[] colors);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconBackgroundColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
        [Export("setIconBackgroundColor:")]
        StorylyStoryGroupStylingBuilder SetIconBackgroundColor(UIColor color);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setPinIconColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
        [Export("setPinIconColor:")]
        StorylyStoryGroupStylingBuilder SetPinIconColor(UIColor color);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconHeight:(CGFloat)height __attribute__((warn_unused_result("")));
        [Export("setIconHeight:")]
        StorylyStoryGroupStylingBuilder SetIconHeight(nfloat height);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconWidth:(CGFloat)width __attribute__((warn_unused_result("")));
        [Export("setIconWidth:")]
        StorylyStoryGroupStylingBuilder SetIconWidth(nfloat width);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconCornerRadius:(CGFloat)radius __attribute__((warn_unused_result("")));
        [Export("setIconCornerRadius:")]
        StorylyStoryGroupStylingBuilder SetIconCornerRadius(nfloat radius);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconThematicImageLabel:(NSString * _Nullable)label __attribute__((warn_unused_result("")));
        [Export("setIconThematicImageLabel:")]
        StorylyStoryGroupStylingBuilder SetIconThematicImageLabel([NullAllowed] string label);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setIconBorderAnimation:(enum StoryGroupAnimation)animation __attribute__((warn_unused_result("")));
        [Export("setIconBorderAnimation:")]
        StorylyStoryGroupStylingBuilder SetIconBorderAnimation(StoryGroupAnimation animation);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setTitleSeenColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
        [Export("setTitleSeenColor:")]
        StorylyStoryGroupStylingBuilder SetTitleSeenColor(UIColor color);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setTitleNotSeenColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
        [Export("setTitleNotSeenColor:")]
        StorylyStoryGroupStylingBuilder SetTitleNotSeenColor(UIColor color);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setTitleLineCount:(NSInteger)count __attribute__((warn_unused_result("")));
        [Export("setTitleLineCount:")]
        StorylyStoryGroupStylingBuilder SetTitleLineCount(nint count);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setTitleFont:(UIFont * _Nullable)font __attribute__((warn_unused_result("")));
        [Export("setTitleFont:")]
        StorylyStoryGroupStylingBuilder SetTitleFont([NullAllowed] UIFont font);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setTitleVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
        [Export("setTitleVisibility:")]
        StorylyStoryGroupStylingBuilder SetTitleVisibility(bool isVisible);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setSize:(enum StoryGroupSize)size __attribute__((warn_unused_result("")));
        [Export("setSize:")]
        StorylyStoryGroupStylingBuilder SetSize(StoryGroupSize size);

        // -(StorylyStoryGroupStylingBuilder * _Nonnull)setCustomGroupViewFactory:(id<StoryGroupViewFactory> _Nullable)factory __attribute__((warn_unused_result(“”)));
        [Export("setCustomGroupViewFactory:")]
        StorylyStoryGroupStylingBuilder SetCustomGroupViewFactory([NullAllowed] StoryGroupViewFactory factory);

        // -(StorylyStoryGroupStyling * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyStoryGroupStyling Build();
    }

    // @interface StorylyShareConfig : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StorylyShareConfig
    {
    }

    // @interface StorylyShareConfigBuilder : NSObject
    [BaseType(typeof(NSObject))]
    interface StorylyShareConfigBuilder
    {
        // -(StorylyShareConfigBuilder * _Nonnull)setShareUrl:(NSString * _Nonnull)url __attribute__((warn_unused_result("")));
        [Export("setShareUrl:")]
        StorylyShareConfigBuilder SetShareUrl(string url);

        // -(StorylyShareConfigBuilder * _Nonnull)setFacebookAppID:(NSString * _Nonnull)id __attribute__((warn_unused_result("")));
        [Export("setFacebookAppID:")]
        StorylyShareConfigBuilder SetFacebookAppID(string id);

        // -(StorylyShareConfigBuilder * _Nonnull)setAppLogoVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
		[Export ("setAppLogoVisibility:")]
		StorylyShareConfigBuilder SetAppLogoVisibility (bool isVisible);

        // -(StorylyShareConfig * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyShareConfig Build();
    }

    // @interface StorylyProductConfig : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface StorylyProductConfig
    {
    }

    // @interface StorylyProductConfigBuilder : NSObject
    [BaseType(typeof(NSObject))]
    interface StorylyProductConfigBuilder
    {
        // -(StorylyProductConfigBuilder * _Nonnull)setFallbackAvailability:(BOOL)isEnabled __attribute__((warn_unused_result("")));
        [Export("setFallbackAvailability:")]
        StorylyProductConfigBuilder SetFallbackAvailability(bool isEnabled);

        // -(StorylyProductConfigBuilder * _Nonnull)setCartEnabled:(BOOL)isEnabled __attribute__((warn_unused_result("")));
        [Export("setCartEnabled:")]
        StorylyProductConfigBuilder SetCartEnabled(bool isEnabled);

        // -(StorylyProductConfigBuilder * _Nonnull)setProductFeed:(NSDictionary<NSString *,NSArray<STRProductItem *> *> * _Nullable)feed __attribute__((warn_unused_result("")));
        [Export("setProductFeed:")]
        StorylyProductConfigBuilder SetProductFeed([NullAllowed] NSDictionary<NSString, NSMutableArray<STRProductItem>> feed);

        // -(StorylyProductConfig * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyProductConfig Build();
    }

    // @interface STRVerticalFeedView : UIView
	[BaseType (typeof(UIView))]
	interface STRVerticalFeedView
	{
		// @property (nonatomic, strong) StorylyVerticalFeedInit * _Nonnull storylyVerticalFeedInit;
		[Export ("storylyVerticalFeedInit", ArgumentSemantic.Strong)]
		StorylyVerticalFeedInit StorylyVerticalFeedInit { get; set; }

		// @property (nonatomic, weak) UIViewController * _Nullable rootViewController;
		[NullAllowed, Export ("rootViewController", ArgumentSemantic.Weak)]
		UIViewController RootViewController { get; set; }

		[Wrap ("WeakStorylyVerticalFeedDelegate")]
		[NullAllowed]
		StorylyVerticalFeedDelegate StorylyVerticalFeedDelegate { get; set; }

		// @property (nonatomic, weak) id<StorylyVerticalFeedDelegate> _Nullable storylyVerticalFeedDelegate;
		[NullAllowed, Export ("storylyVerticalFeedDelegate", ArgumentSemantic.Weak)]
		NSObject WeakStorylyVerticalFeedDelegate { get; set; }

		[Wrap ("WeakStorylyVerticalFeedProductDelegate")]
		[NullAllowed]
		StorylyVerticalFeedProductDelegate StorylyVerticalFeedProductDelegate { get; set; }

		// @property (nonatomic, weak) id<StorylyVerticalFeedProductDelegate> _Nullable storylyVerticalFeedProductDelegate;
		[NullAllowed, Export ("storylyVerticalFeedProductDelegate", ArgumentSemantic.Weak)]
		NSObject WeakStorylyVerticalFeedProductDelegate { get; set; }

		// -(void)layoutSubviews;
		[Export ("layoutSubviews")]
		void LayoutSubviews ();

		// @property (copy, nonatomic) NSString * _Nullable accessibilityLabel;
		[NullAllowed, Export ("accessibilityLabel")]
		string AccessibilityLabel { get; set; }

		// @property (copy, nonatomic) NSString * _Nullable accessibilityIdentifier;
		[NullAllowed, Export ("accessibilityIdentifier")]
		string AccessibilityIdentifier { get; set; }

		// -(void)willMoveToWindow:(UIWindow * _Nullable)newWindow;
		[Export ("willMoveToWindow:")]
		void WillMoveToWindow ([NullAllowed] UIWindow newWindow);

		// -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
		[Export ("initWithFrame:")]
		[DesignatedInitializer]
		IntPtr Constructor (CGRect frame);
	}

    // @interface StorylyVerticalFeedBarStyling : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface StorylyVerticalFeedBarStyling
	{
	}

	// @interface StorylyVerticalFeedBarStylingBuilder : NSObject
	[BaseType (typeof(NSObject))]
	interface StorylyVerticalFeedBarStylingBuilder
	{
		// -(StorylyVerticalFeedBarStylingBuilder * _Nonnull)setSection:(NSInteger)count __attribute__((warn_unused_result("")));
		[Export ("setSection:")]
		StorylyVerticalFeedBarStylingBuilder SetSection (nint count);

		// -(StorylyVerticalFeedBarStylingBuilder * _Nonnull)setHorizontalEdgePadding:(CGFloat)padding __attribute__((warn_unused_result("")));
		[Export ("setHorizontalEdgePadding:")]
		StorylyVerticalFeedBarStylingBuilder SetHorizontalEdgePadding (nfloat padding);

		// -(StorylyVerticalFeedBarStylingBuilder * _Nonnull)setVerticalEdgePadding:(CGFloat)padding __attribute__((warn_unused_result("")));
		[Export ("setVerticalEdgePadding:")]
		StorylyVerticalFeedBarStylingBuilder SetVerticalEdgePadding (nfloat padding);

		// -(StorylyVerticalFeedBarStylingBuilder * _Nonnull)setHorizontalPaddingBetweenItems:(CGFloat)padding __attribute__((warn_unused_result("")));
		[Export ("setHorizontalPaddingBetweenItems:")]
		StorylyVerticalFeedBarStylingBuilder SetHorizontalPaddingBetweenItems (nfloat padding);

		// -(StorylyVerticalFeedBarStylingBuilder * _Nonnull)setVerticalPaddingBetweenItems:(CGFloat)padding __attribute__((warn_unused_result("")));
		[Export ("setVerticalPaddingBetweenItems:")]
		StorylyVerticalFeedBarStylingBuilder SetVerticalPaddingBetweenItems (nfloat padding);

		// -(StorylyVerticalFeedBarStyling * _Nonnull)build __attribute__((warn_unused_result("")));
		[Export("build")]
		StorylyVerticalFeedBarStyling Build();
	}

	// @interface StorylyVerticalFeedBarView : STRVerticalFeedView
	[BaseType (typeof(STRVerticalFeedView))]
	interface StorylyVerticalFeedBarView
	{
		// -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
		[Export ("initWithFrame:")]
		[DesignatedInitializer]
		IntPtr Constructor (CGRect frame);
	}

	// @interface StorylyVerticalFeedConfig : STRConfig
	[BaseType (typeof(STRConfig))]
	interface StorylyVerticalFeedConfig
	{
	}

	// @interface StorylyVerticalFeedConfigBuilder : Builder
	[BaseType (typeof(STRConfigBuilder))]
	interface StorylyVerticalFeedConfigBuilder
	{
		// -(instancetype _Nonnull)setVerticalFeedConfig:(StorylyVerticalFeedCustomization * _Nonnull)styling __attribute__((warn_unused_result("")));
		[Export ("setVerticalFeedConfig:")]
		StorylyVerticalFeedConfigBuilder SetVerticalFeedConfig (StorylyVerticalFeedCustomization styling);

		// -(instancetype _Nonnull)setVerticalFeedBarStyling:(StorylyVerticalFeedBarStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
		[Export ("setVerticalFeedBarStyling:")]
		StorylyVerticalFeedConfigBuilder SetVerticalFeedBarStyling (StorylyVerticalFeedBarStyling styling);

		// -(instancetype _Nonnull)setVerticalFeedGroupStyling:(StorylyVerticalFeedGroupStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
		[Export ("setVerticalFeedGroupStyling:")]
		StorylyVerticalFeedConfigBuilder SetVerticalFeedGroupStyling (StorylyVerticalFeedGroupStyling styling);

        // -(StorylyVerticalFeedConfig * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyVerticalFeedConfig Build();
    }

    // @interface StorylyVerticalFeedCustomization : STRStoryStyling
    [BaseType(typeof(STRStoryStyling))]
    interface StorylyVerticalFeedCustomization
    {
    }

    // @interface StorylyVerticalFeedCustomizationBuilder : STRStoryBuilder
    [BaseType(typeof(STRStoryBuilder))]
    interface StorylyVerticalFeedCustomizationBuilder
    {
        // -(StorylyVerticalFeedCustomizationBuilder * _Nonnull)setProgressBarVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
        [Export("setProgressBarVisibility:")]
        StorylyVerticalFeedCustomizationBuilder SetProgressBarVisibility(bool isVisible);

        // -(StorylyVerticalFeedCustomizationBuilder * _Nonnull)setLikeButtonVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
        [Export("setLikeButtonVisibility:")]
        StorylyVerticalFeedCustomizationBuilder SetLikeButtonVisibility(bool isVisible);

        // -(StorylyVerticalFeedCustomizationBuilder * _Nonnull)setLikeButtonIcon:(UIImage * _Nullable)icon __attribute__((warn_unused_result("")));
        [Export("setLikeButtonIcon:")]
        StorylyVerticalFeedCustomizationBuilder SetLikeButtonIcon([NullAllowed] UIImage icon);

        // -(StorylyVerticalFeedCustomizationBuilder * _Nonnull)setShareButtonVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
        [Export("setShareButtonVisibility:")]
        StorylyVerticalFeedCustomizationBuilder SetShareButtonVisibility(bool isVisible);

        // -(StorylyVerticalFeedCustomization * _Nonnull)build __attribute__((warn_unused_result("")));
        [Export("build")]
        StorylyVerticalFeedCustomization Build();
    }

    // @protocol StorylyVerticalFeedDelegate
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
	interface StorylyVerticalFeedDelegate
	{
		// @optional -(void)verticalFeedLoaded:(STRVerticalFeedView * _Nonnull)view feedGroupList:(NSArray<VerticalFeedGroup *> * _Nonnull)feedGroupList dataSource:(enum StorylyDataSource)dataSource;
		[Export ("verticalFeedLoaded:feedGroupList:dataSource:")]
		void VerticalFeedLoaded (STRVerticalFeedView view, VerticalFeedGroup[] feedGroupList, StorylyDataSource dataSource);

		// @optional -(void)verticalFeedLoadFailed:(STRVerticalFeedView * _Nonnull)view errorMessage:(NSString * _Nonnull)errorMessage;
		[Export ("verticalFeedLoadFailed:errorMessage:")]
		void VerticalFeedLoadFailed (STRVerticalFeedView view, string errorMessage);

		// @optional -(void)verticalFeedActionClicked:(STRVerticalFeedView * _Nonnull)view rootViewController:(UIViewController * _Nonnull)rootViewController feedItem:(VerticalFeedItem * _Nonnull)feedItem;
		[Export ("verticalFeedActionClicked:rootViewController:feedItem:")]
		void VerticalFeedActionClicked (STRVerticalFeedView view, UIViewController rootViewController, VerticalFeedItem feedItem);

		// @optional -(void)verticalFeedPresented:(STRVerticalFeedView * _Nonnull)view;
		[Export ("verticalFeedPresented:")]
		void VerticalFeedPresented (STRVerticalFeedView view);

		// @optional -(void)verticalFeedPresentFailed:(STRVerticalFeedView * _Nonnull)view errorMessage:(NSString * _Nonnull)errorMessage;
		[Export ("verticalFeedPresentFailed:errorMessage:")]
		void VerticalFeedPresentFailed (STRVerticalFeedView view, string errorMessage);

		// @optional -(void)verticalFeedDismissed:(STRVerticalFeedView * _Nonnull)view;
		[Export ("verticalFeedDismissed:")]
		void VerticalFeedDismissed (STRVerticalFeedView view);

		// @optional -(void)verticalFeedUserInteracted:(STRVerticalFeedView * _Nonnull)view feedGroup:(VerticalFeedGroup * _Nonnull)feedGroup feedItem:(VerticalFeedItem * _Nonnull)feedItem feedItemComponent:(VerticalFeedItemComponent * _Nonnull)feedItemComponent;
		[Export ("verticalFeedUserInteracted:feedGroup:feedItem:feedItemComponent:")]
		void VerticalFeedUserInteracted (STRVerticalFeedView view, VerticalFeedGroup feedGroup, VerticalFeedItem feedItem, VerticalFeedItemComponent feedItemComponent);

		// @optional -(void)verticalFeedEvent:(STRVerticalFeedView * _Nonnull)view event:(enum VerticalFeedEvent)event feedGroup:(VerticalFeedGroup * _Nullable)feedGroup feedItem:(VerticalFeedItem * _Nullable)feedItem feedItemComponent:(VerticalFeedItemComponent * _Nullable)feedItemComponent;
		[Export ("verticalFeedEvent:event:feedGroup:feedItem:feedItemComponent:")]
		void VerticalFeedEvent (STRVerticalFeedView view, VerticalFeedEvent @event, [NullAllowed] VerticalFeedGroup feedGroup, [NullAllowed] VerticalFeedItem feedItem, [NullAllowed] VerticalFeedItemComponent feedItemComponent);
	}

	// @interface StorylyVerticalFeedGroupStyling : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface StorylyVerticalFeedGroupStyling
	{
	}

	// @interface StorylyVerticalFeedGroupStylingBuilder : NSObject
	[BaseType (typeof(NSObject))]
	interface StorylyVerticalFeedGroupStylingBuilder
	{
		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setIconBackgroundColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
		[Export ("setIconBackgroundColor:")]
		StorylyVerticalFeedGroupStylingBuilder SetIconBackgroundColor (UIColor color);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setIconHeight:(CGFloat)height __attribute__((warn_unused_result("")));
		[Export ("setIconHeight:")]
		StorylyVerticalFeedGroupStylingBuilder SetIconHeight (nfloat height);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setIconCornerRadius:(CGFloat)radius __attribute__((warn_unused_result("")));
		[Export ("setIconCornerRadius:")]
		StorylyVerticalFeedGroupStylingBuilder SetIconCornerRadius (nfloat radius);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setIconThematicImageLabel:(NSString * _Nullable)label __attribute__((warn_unused_result("")));
		[Export ("setIconThematicImageLabel:")]
		StorylyVerticalFeedGroupStylingBuilder SetIconThematicImageLabel ([NullAllowed] string label);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setTitleFont:(UIFont * _Nullable)font __attribute__((warn_unused_result("")));
		[Export ("setTitleFont:")]
		StorylyVerticalFeedGroupStylingBuilder SetTitleFont ([NullAllowed] UIFont font);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setTitleVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
		[Export ("setTitleVisibility:")]
		StorylyVerticalFeedGroupStylingBuilder SetTitleVisibility (bool isVisible);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setGroupOrder:(enum VerticalFeedGroupOrder)order __attribute__((warn_unused_result("")));
		[Export ("setGroupOrder:")]
		StorylyVerticalFeedGroupStylingBuilder SetGroupOrder (VerticalFeedGroupOrder order);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setImpressionIcon:(UIImage * _Nonnull)image __attribute__((warn_unused_result("")));
		[Export ("setImpressionIcon:")]
		StorylyVerticalFeedGroupStylingBuilder SetImpressionIcon (UIImage image);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setLikeIcon:(UIImage * _Nonnull)image __attribute__((warn_unused_result("")));
		[Export ("setLikeIcon:")]
		StorylyVerticalFeedGroupStylingBuilder SetLikeIcon (UIImage image);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setTextColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
		[Export ("setTextColor:")]
		StorylyVerticalFeedGroupStylingBuilder SetTextColor (UIColor color);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setMinImpressionCountToShowIcon:(NSInteger)count __attribute__((warn_unused_result("")));
		[Export ("setMinImpressionCountToShowIcon:")]
		StorylyVerticalFeedGroupStylingBuilder SetMinImpressionCountToShowIcon (nint count);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setMinLikeCountToShowIcon:(NSInteger)count __attribute__((warn_unused_result("")));
		[Export ("setMinLikeCountToShowIcon:")]
		StorylyVerticalFeedGroupStylingBuilder SetMinLikeCountToShowIcon (nint count);

		// -(StorylyVerticalFeedGroupStylingBuilder * _Nonnull)setTypeIndicatorVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
		[Export ("setTypeIndicatorVisibility:")]
		StorylyVerticalFeedGroupStylingBuilder SetTypeIndicatorVisibility (bool isVisible);

		// -(StorylyVerticalFeedGroupStyling * _Nonnull)build __attribute__((warn_unused_result("")));
		[Export("build")]
		StorylyVerticalFeedGroupStyling Build();
	}

    // @interface StorylyVerticalFeedInit : NSObject
    [BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface StorylyVerticalFeedInit
	{
		// @property (nonatomic, strong) StorylyVerticalFeedConfig * _Nonnull config;
		[Export ("config", ArgumentSemantic.Strong)]
		StorylyVerticalFeedConfig Config { get; set; }

		// -(instancetype _Nonnull)initWithStorylyId:(NSString * _Nonnull)storylyId config:(StorylyVerticalFeedConfig * _Nonnull)config __attribute__((objc_designated_initializer));
		[Export ("initWithStorylyId:config:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string storylyId, StorylyVerticalFeedConfig config);
	}

    // @protocol StorylyVerticalFeedPresenterDelegate
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
	interface StorylyVerticalFeedPresenterDelegate
	{
		// @optional -(void)verticalFeedLoaded:(StorylyVerticalFeedPresenterView * _Nonnull)view feedGroupList:(NSArray<VerticalFeedGroup *> * _Nonnull)feedGroupList dataSource:(enum StorylyDataSource)dataSource;
		[Export ("verticalFeedLoaded:feedGroupList:dataSource:")]
		void VerticalFeedLoaded (StorylyVerticalFeedPresenterView view, VerticalFeedGroup[] feedGroupList, StorylyDataSource dataSource);

		// @optional -(void)verticalFeedLoadFailed:(StorylyVerticalFeedPresenterView * _Nonnull)view errorMessage:(NSString * _Nonnull)errorMessage;
		[Export ("verticalFeedLoadFailed:errorMessage:")]
		void VerticalFeedLoadFailed (StorylyVerticalFeedPresenterView view, string errorMessage);

		// @optional -(void)verticalFeedActionClicked:(StorylyVerticalFeedPresenterView * _Nonnull)view feedItem:(VerticalFeedItem * _Nonnull)feedItem;
		[Export ("verticalFeedActionClicked:feedItem:")]
		void VerticalFeedActionClicked (StorylyVerticalFeedPresenterView view, VerticalFeedItem feedItem);

		// @optional -(void)verticalFeedPresented:(StorylyVerticalFeedPresenterView * _Nonnull)view;
		[Export ("verticalFeedPresented:")]
		void VerticalFeedPresented (StorylyVerticalFeedPresenterView view);

		// @optional -(void)verticalFeedPresentFailed:(StorylyVerticalFeedPresenterView * _Nonnull)view errorMessage:(NSString * _Nonnull)errorMessage;
		[Export ("verticalFeedPresentFailed:errorMessage:")]
		void VerticalFeedPresentFailed (StorylyVerticalFeedPresenterView view, string errorMessage);

		// @optional -(void)verticalFeedDismissed:(StorylyVerticalFeedPresenterView * _Nonnull)view;
		[Export ("verticalFeedDismissed:")]
		void VerticalFeedDismissed (StorylyVerticalFeedPresenterView view);

		// @optional -(void)verticalFeedUserInteracted:(StorylyVerticalFeedPresenterView * _Nonnull)view feedGroup:(VerticalFeedGroup * _Nonnull)feedGroup feedItem:(VerticalFeedItem * _Nonnull)feedItem feedItemComponent:(VerticalFeedItemComponent * _Nonnull)feedItemComponent;
		[Export ("verticalFeedUserInteracted:feedGroup:feedItem:feedItemComponent:")]
		void VerticalFeedUserInteracted (StorylyVerticalFeedPresenterView view, VerticalFeedGroup feedGroup, VerticalFeedItem feedItem, VerticalFeedItemComponent feedItemComponent);

		// @optional -(void)verticalFeedEvent:(StorylyVerticalFeedPresenterView * _Nonnull)view event:(enum VerticalFeedEvent)event feedGroup:(VerticalFeedGroup * _Nullable)feedGroup feedItem:(VerticalFeedItem * _Nullable)feedItem feedItemComponent:(VerticalFeedItemComponent * _Nullable)feedItemComponent;
		[Export ("verticalFeedEvent:event:feedGroup:feedItem:feedItemComponent:")]
		void VerticalFeedEvent (StorylyVerticalFeedPresenterView view, VerticalFeedEvent @event, [NullAllowed] VerticalFeedGroup feedGroup, [NullAllowed] VerticalFeedItem feedItem, [NullAllowed] VerticalFeedItemComponent feedItemComponent);
	}

    // @protocol StorylyVerticalFeedPresenterProductDelegate
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
	interface StorylyVerticalFeedPresenterProductDelegate
	{
		// @optional -(void)verticalFeedHydration:(StorylyVerticalFeedPresenterView * _Nonnull)view products:(NSArray<STRProductInformation *> * _Nonnull)products;
		[Export ("verticalFeedHydration:products:")]
		void VerticalFeedHydration (StorylyVerticalFeedPresenterView view, STRProductInformation[] products);

		// @optional -(void)verticalFeedEvent:(StorylyVerticalFeedPresenterView * _Nonnull)view event:(enum VerticalFeedEvent)event;
		[Export ("verticalFeedEvent:event:")]
		void VerticalFeedEvent (StorylyVerticalFeedPresenterView view, VerticalFeedEvent @event);

		// @optional -(void)verticalFeedUpdateCartEventWithView:(StorylyVerticalFeedPresenterView * _Nonnull)view event:(enum VerticalFeedEvent)event cart:(STRCart * _Nullable)cart change:(STRCartItem * _Nullable)change onSuccess:(void (^ _Nullable)(STRCart * _Nullable))onSuccess onFail:(void (^ _Nullable)(STRCartEventResult * _Nonnull))onFail;
		[Export ("verticalFeedUpdateCartEventWithView:event:cart:change:onSuccess:onFail:")]
		void VerticalFeedUpdateCartEventWithView (StorylyVerticalFeedPresenterView view, VerticalFeedEvent @event, [NullAllowed] STRCart cart, [NullAllowed] STRCartItem change, [NullAllowed] Action<STRCart> onSuccess, [NullAllowed] Action<STRCartEventResult> onFail);
	}

	// @interface StorylyVerticalFeedPresenterView : UIView
	[BaseType (typeof(UIView))]
	interface StorylyVerticalFeedPresenterView
	{
		// @property (nonatomic, strong) StorylyVerticalFeedInit * _Nonnull storylyVerticalFeedInit;
		[Export ("storylyVerticalFeedInit", ArgumentSemantic.Strong)]
		StorylyVerticalFeedInit StorylyVerticalFeedInit { get; set; }

		// @property (nonatomic, weak) UIViewController * _Nullable rootViewController;
		[NullAllowed, Export ("rootViewController", ArgumentSemantic.Weak)]
		UIViewController RootViewController { get; set; }

		[Wrap ("WeakStorylyVerticalFeedDelegate")]
		[NullAllowed]
		StorylyVerticalFeedPresenterDelegate StorylyVerticalFeedDelegate { get; set; }

		// @property (nonatomic, weak) id<StorylyVerticalFeedPresenterDelegate> _Nullable storylyVerticalFeedDelegate;
		[NullAllowed, Export ("storylyVerticalFeedDelegate", ArgumentSemantic.Weak)]
		NSObject WeakStorylyVerticalFeedDelegate { get; set; }

		[Wrap ("WeakStorylyVerticalFeedProductDelegate")]
		[NullAllowed]
		StorylyVerticalFeedPresenterProductDelegate StorylyVerticalFeedProductDelegate { get; set; }

		// @property (nonatomic, weak) id<StorylyVerticalFeedPresenterProductDelegate> _Nullable storylyVerticalFeedProductDelegate;
		[NullAllowed, Export ("storylyVerticalFeedProductDelegate", ArgumentSemantic.Weak)]
		NSObject WeakStorylyVerticalFeedProductDelegate { get; set; }

		// -(void)willMoveToWindow:(UIWindow * _Nullable)newWindow;
		[Export ("willMoveToWindow:")]
		void WillMoveToWindow ([NullAllowed] UIWindow newWindow);

		// -(void)pause;
		[Export ("pause")]
		void Pause ();

		// -(void)play;
		[Export ("play")]
		void Play ();

		// -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
		[Export ("initWithFrame:")]
		[DesignatedInitializer]
		IntPtr Constructor (CGRect frame);
	}

    // @protocol StorylyVerticalFeedProductDelegate
    [BaseType(typeof(NSObject))]
    [Protocol, Model]
	interface StorylyVerticalFeedProductDelegate
	{
		// @optional -(void)verticalFeedHydration:(STRVerticalFeedView * _Nonnull)view products:(NSArray<STRProductInformation *> * _Nonnull)products;
		[Export ("verticalFeedHydration:products:")]
		void VerticalFeedHydration (STRVerticalFeedView view, STRProductInformation[] products);

		// @optional -(void)verticalFeedEvent:(STRVerticalFeedView * _Nonnull)view event:(enum VerticalFeedEvent)event;
		[Export ("verticalFeedEvent:event:")]
		void VerticalFeedEvent (STRVerticalFeedView view, VerticalFeedEvent @event);

		// @optional -(void)verticalFeedUpdateCartEventWithView:(STRVerticalFeedView * _Nonnull)view event:(enum VerticalFeedEvent)event cart:(STRCart * _Nullable)cart change:(STRCartItem * _Nullable)change onSuccess:(void (^ _Nullable)(STRCart * _Nullable))onSuccess onFail:(void (^ _Nullable)(STRCartEventResult * _Nonnull))onFail;
		[Export ("verticalFeedUpdateCartEventWithView:event:cart:change:onSuccess:onFail:")]
		void VerticalFeedUpdateCartEventWithView (STRVerticalFeedView view, VerticalFeedEvent @event, [NullAllowed] STRCart cart, [NullAllowed] STRCartItem change, [NullAllowed] Action<STRCart> onSuccess, [NullAllowed] Action<STRCartEventResult> onFail);
	}

	// @interface StorylyVerticalFeedView : STRVerticalFeedView
	[BaseType (typeof(STRVerticalFeedView))]
	interface StorylyVerticalFeedView
	{
		// -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
		[Export ("initWithFrame:")]
		[DesignatedInitializer]
        IntPtr Constructor (CGRect frame);
    }

    // @interface VerticalFeedItemComponent : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface VerticalFeedItemComponent
	{
        // @property (readonly, copy, nonatomic) NSString * _Nonnull id;
        [Export("id")]
        string Id { get; }

        // @property (readonly, nonatomic) enum VerticalFeedItemComponentType type;
        [Export("type")]
        VerticalFeedItemComponentType Type { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nullable customPayload;
        [NullAllowed, Export("customPayload")]
        string CustomPayload { get; }
    }

	// @interface VerticalFeedButtonComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedButtonComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:text:actionUrl:products:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string text, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedCommentComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedCommentComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:text:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string text, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedEmojiComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedEmojiComponent
	{
		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull emojiCodes;
		[Export ("emojiCodes", ArgumentSemantic.Copy)]
		string[] EmojiCodes { get; }

		// @property (readonly, nonatomic) NSInteger selectedEmojiIndex;
		[Export ("selectedEmojiIndex")]
		nint SelectedEmojiIndex { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id emojiCodes:(NSArray<NSString *> * _Nonnull)emojiCodes selectedEmojiIndex:(NSInteger)selectedEmojiIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:emojiCodes:selectedEmojiIndex:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string[] emojiCodes, nint selectedEmojiIndex, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedEventHelper : NSObject
	[BaseType (typeof(NSObject), Name = "_TtC7Storyly23VerticalFeedEventHelper")]
	interface VerticalFeedEventHelper
	{
		// +(NSString * _Nonnull)verticalFeedEventNameWithEvent:(enum VerticalFeedEvent)event __attribute__((warn_unused_result("")));
		[Static]
		[Export ("verticalFeedEventNameWithEvent:")]
		string VerticalFeedEventNameWithEvent (VerticalFeedEvent @event);
	}

	// @interface VerticalFeedGroup : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface VerticalFeedGroup
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull uniqueId;
		[Export ("uniqueId")]
		string UniqueId { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull title;
		[Export ("title")]
		string Title { get; }

		// @property (readonly, copy, nonatomic) NSURL * _Nullable iconUrl;
		[NullAllowed, Export ("iconUrl", ArgumentSemantic.Copy)]
		NSUrl IconUrl { get; }

		// @property (readonly, copy, nonatomic) NSURL * _Nullable iconVideoUrl;
		[NullAllowed, Export ("iconVideoUrl", ArgumentSemantic.Copy)]
		NSUrl IconVideoUrl { get; }

		// @property (readonly, copy, nonatomic) NSURL * _Nullable iconVideoThumbnailUrl;
		[NullAllowed, Export ("iconVideoThumbnailUrl", ArgumentSemantic.Copy)]
		NSUrl IconVideoThumbnailUrl { get; }

		// @property (readonly, nonatomic) NSInteger index;
		[Export ("index")]
		nint Index { get; }

		// @property (readonly, nonatomic) BOOL seen;
		[Export ("seen")]
		bool Seen { get; }

		// @property (readonly, copy, nonatomic) NSArray<VerticalFeedItem *> * _Nonnull feedList;
		[Export ("feedList", ArgumentSemantic.Copy)]
		VerticalFeedItem[] FeedList { get; }

		// @property (readonly, nonatomic) BOOL pinned;
		[Export ("pinned")]
		bool Pinned { get; }

		// @property (readonly, nonatomic) enum VerticalFeedGroupType type;
		[Export ("type")]
		VerticalFeedGroupType Type { get; }

		// @property (readonly, nonatomic, strong) VerticalFeedGroupStyle * _Nullable style;
		[NullAllowed, Export ("style", ArgumentSemantic.Strong)]
		VerticalFeedGroupStyle Style { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable name;
		[NullAllowed, Export ("name")]
		string Name { get; }

		// @property (readonly, nonatomic) BOOL nudge;
		[Export ("nudge")]
		bool Nudge { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title iconUrl:(NSURL * _Nullable)iconUrl iconVideoUrl:(NSURL * _Nullable)iconVideoUrl iconVideoThumbnailUrl:(NSURL * _Nullable)iconVideoThumbnailUrl index:(NSInteger)index seen:(BOOL)seen feedList:(NSArray<VerticalFeedItem *> * _Nonnull)feedList pinned:(BOOL)pinned type:(enum VerticalFeedGroupType)type style:(VerticalFeedGroupStyle * _Nullable)style name:(NSString * _Nullable)name nudge:(BOOL)nudge __attribute__((objc_designated_initializer));
		[Export ("initWithId:title:iconUrl:iconVideoUrl:iconVideoThumbnailUrl:index:seen:feedList:pinned:type:style:name:nudge:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, string title, [NullAllowed] NSUrl iconUrl, [NullAllowed] NSUrl iconVideoUrl, [NullAllowed] NSUrl iconVideoThumbnailUrl, nint index, bool seen, VerticalFeedItem[] feedList, bool pinned, VerticalFeedGroupType type, [NullAllowed] VerticalFeedGroupStyle style, [NullAllowed] string name, bool nudge);
	}

	// @interface VerticalFeedGroupBadgeStyle : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface VerticalFeedGroupBadgeStyle
	{
		// @property (readonly, copy, nonatomic) NSString * _Nullable text;
		[NullAllowed, Export ("text")]
		string Text { get; }

		// @property (readonly, nonatomic, strong) UIColor * _Nullable textColor;
		[NullAllowed, Export ("textColor", ArgumentSemantic.Strong)]
		UIColor TextColor { get; }

		// @property (readonly, nonatomic, strong) UIColor * _Nullable backgroundColor;
		[NullAllowed, Export ("backgroundColor", ArgumentSemantic.Strong)]
		UIColor BackgroundColor { get; }

		// @property (readonly, nonatomic, strong) NSNumber * _Nullable endTime;
		[NullAllowed, Export ("endTime", ArgumentSemantic.Strong)]
		NSNumber EndTime { get; }

		// @property (readonly, getter = template, copy, nonatomic) NSString * _Nullable template_;
		[NullAllowed, Export ("template_")]
		string Template_ { [Bind ("template")] get; }

		// -(instancetype _Nonnull)initWithText:(NSString * _Nullable)text textColor:(UIColor * _Nullable)textColor backgroundColor:(UIColor * _Nullable)backgroundColor endTime:(NSNumber * _Nullable)endTime template:(NSString * _Nullable)template_ __attribute__((objc_designated_initializer));
		[Export ("initWithText:textColor:backgroundColor:endTime:template:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] string text, [NullAllowed] UIColor textColor, [NullAllowed] UIColor backgroundColor, [NullAllowed] NSNumber endTime, [NullAllowed] string template_);
	}

	// @interface VerticalFeedGroupStyle : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface VerticalFeedGroupStyle
	{
		// @property (readonly, copy, nonatomic) NSArray<UIColor *> * _Nullable borderUnseenColors;
		[NullAllowed, Export ("borderUnseenColors", ArgumentSemantic.Copy)]
		UIColor[] BorderUnseenColors { get; }

		// @property (readonly, nonatomic, strong) UIColor * _Nullable textUnseenColor;
		[NullAllowed, Export ("textUnseenColor", ArgumentSemantic.Strong)]
		UIColor TextUnseenColor { get; }

		// @property (readonly, nonatomic, strong) VerticalFeedGroupBadgeStyle * _Nullable badge;
		[NullAllowed, Export ("badge", ArgumentSemantic.Strong)]
		VerticalFeedGroupBadgeStyle Badge { get; }

		// -(instancetype _Nonnull)initWithBorderUnseenColors:(NSArray<UIColor *> * _Nullable)borderUnseenColors textUnseenColor:(UIColor * _Nullable)textUnseenColor badge:(VerticalFeedGroupBadgeStyle * _Nullable)badge __attribute__((objc_designated_initializer));
		[Export ("initWithBorderUnseenColors:textUnseenColor:badge:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] UIColor[] borderUnseenColors, [NullAllowed] UIColor textUnseenColor, [NullAllowed] VerticalFeedGroupBadgeStyle badge);
	}

	// @interface VerticalFeedImageQuizComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedImageQuizComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull title;
		[Export ("title")]
		string Title { get; }

		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nullable options;
		[NullAllowed, Export ("options", ArgumentSemantic.Copy)]
		string[] Options { get; }

		// @property (readonly, nonatomic, strong) NSNumber * _Nullable rightAnswerIndex;
		[NullAllowed, Export ("rightAnswerIndex", ArgumentSemantic.Strong)]
		NSNumber RightAnswerIndex { get; }

		// @property (readonly, nonatomic) NSInteger selectedOptionIndex;
		[Export ("selectedOptionIndex")]
		nint SelectedOptionIndex { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nullable)options rightAnswerIndex:(NSNumber * _Nullable)rightAnswerIndex selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:title:options:rightAnswerIndex:selectedOptionIndex:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string title, [NullAllowed] string[] options, [NullAllowed] NSNumber rightAnswerIndex, nint selectedOptionIndex, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedItem : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface VerticalFeedItem
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull uniqueId;
		[Export ("uniqueId")]
		string UniqueId { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull title;
		[Export ("title")]
		string Title { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable name;
		[NullAllowed, Export ("name")]
		string Name { get; }

		// @property (readonly, nonatomic) NSInteger index;
		[Export ("index")]
		nint Index { get; }

		// @property (readonly, nonatomic) BOOL seen;
		[Export ("seen")]
		bool Seen { get; }

		// @property (readonly, nonatomic) NSInteger currentTime;
		[Export ("currentTime")]
		nint CurrentTime { get; }

		// @property (copy, nonatomic) NSURL * _Nullable previewUrl;
		[NullAllowed, Export ("previewUrl", ArgumentSemantic.Copy)]
		NSUrl PreviewUrl { get; set; }

		// @property (readonly, copy, nonatomic) NSArray<VerticalFeedItemComponent *> * _Nullable verticalFeedItemComponentList;
		[NullAllowed, Export ("verticalFeedItemComponentList", ArgumentSemantic.Copy)]
		VerticalFeedItemComponent[] VerticalFeedItemComponentList { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable actionProducts;
		[NullAllowed, Export ("actionProducts", ArgumentSemantic.Copy)]
		STRProductItem[] ActionProducts { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id index:(NSInteger)index title:(NSString * _Nonnull)title name:(NSString * _Nullable)name seen:(BOOL)seen currentTime:(NSInteger)currentTime previewUrl:(NSURL * _Nullable)previewUrl verticalFeedItemComponentList:(NSArray<VerticalFeedItemComponent *> * _Nullable)verticalFeedItemComponentList actionUrl:(NSString * _Nullable)actionUrl actionProducts:(NSArray<STRProductItem *> * _Nullable)actionProducts __attribute__((objc_designated_initializer));
		[Export ("initWithId:index:title:name:seen:currentTime:previewUrl:verticalFeedItemComponentList:actionUrl:actionProducts:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string id, nint index, string title, [NullAllowed] string name, bool seen, nint currentTime, [NullAllowed] NSUrl previewUrl, [NullAllowed] VerticalFeedItemComponent[] verticalFeedItemComponentList, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] actionProducts);
	}

	// @interface VerticalFeedItemComponentTypeHelper : NSObject
	[BaseType (typeof(NSObject))]
	interface VerticalFeedItemComponentTypeHelper
	{
		// +(NSString * _Nonnull)verticalFeedItemComponentNameWithComponentType:(enum VerticalFeedItemComponentType)componentType __attribute__((warn_unused_result("")));
		[Static]
		[Export ("verticalFeedItemComponentNameWithComponentType:")]
		string VerticalFeedItemComponentNameWithComponentType (VerticalFeedItemComponentType componentType);
	}

	// @interface VerticalFeedPollComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedPollComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull title;
		[Export ("title")]
		string Title { get; }

		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull options;
		[Export ("options", ArgumentSemantic.Copy)]
		string[] Options { get; }

		// @property (readonly, nonatomic) NSInteger selectedOptionIndex;
		[Export ("selectedOptionIndex")]
		nint SelectedOptionIndex { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nonnull)options selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:title:options:selectedOptionIndex:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string title, string[] options, nint selectedOptionIndex, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedProductCardComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedProductCardComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:text:actionUrl:products:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string text, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedProductCatalogComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedProductCatalogComponent
	{
		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nullable actionUrlList;
		[NullAllowed, Export ("actionUrlList", ArgumentSemantic.Copy)]
		string[] ActionUrlList { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id actionUrlList:(NSArray<NSString *> * _Nullable)actionUrlList products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:actionUrlList:products:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, [NullAllowed] string[] actionUrlList, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedProductTagComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedProductTagComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:actionUrl:products:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedPromoCodeComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedPromoCodeComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:text:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string text, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedQuizComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedQuizComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull title;
		[Export ("title")]
		string Title { get; }

		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull options;
		[Export ("options", ArgumentSemantic.Copy)]
		string[] Options { get; }

		// @property (readonly, nonatomic, strong) NSNumber * _Nullable rightAnswerIndex;
		[NullAllowed, Export ("rightAnswerIndex", ArgumentSemantic.Strong)]
		NSNumber RightAnswerIndex { get; }

		// @property (readonly, nonatomic) NSInteger selectedOptionIndex;
		[Export ("selectedOptionIndex")]
		nint SelectedOptionIndex { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nonnull)options rightAnswerIndex:(NSNumber * _Nullable)rightAnswerIndex selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:title:options:rightAnswerIndex:selectedOptionIndex:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string title, string[] options, [NullAllowed] NSNumber rightAnswerIndex, nint selectedOptionIndex, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedRatingComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedRatingComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull emojiCode;
		[Export ("emojiCode")]
		string EmojiCode { get; }

		// @property (readonly, nonatomic) NSInteger rating;
		[Export ("rating")]
		nint Rating { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id emojiCode:(NSString * _Nonnull)emojiCode rating:(NSInteger)rating customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:emojiCode:rating:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string emojiCode, nint rating, [NullAllowed] string customPayload);
    }

	// @interface VerticalFeedSwipeComponent : VerticalFeedItemComponent
	[BaseType (typeof(VerticalFeedItemComponent))]
	interface VerticalFeedSwipeComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export ("text")]
		string Text { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export ("actionUrl")]
		string ActionUrl { get; }

		// @property (readonly, copy, nonatomic) NSArray<STRProductItem *> * _Nullable products;
		[NullAllowed, Export ("products", ArgumentSemantic.Copy)]
		STRProductItem[] Products { get; }

        // -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text actionUrl:(NSString * _Nullable)actionUrl products:(NSArray<STRProductItem *> * _Nullable)products customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
        [Export("initWithId:text:actionUrl:products:customPayload:")]
        [DesignatedInitializer]
        NativeHandle Constructor(string id, string text, [NullAllowed] string actionUrl, [NullAllowed] STRProductItem[] products, [NullAllowed] string customPayload);
    }

    // @interface STRStoryStyling : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRStoryStyling
    {
    }

    // @interface STRStoryBuilder : NSObject
    [BaseType(typeof(NSObject))]
    interface STRStoryBuilder
    {
        // -(instancetype _Nonnull)setTitleFont:(UIFont * _Nonnull)font __attribute__((warn_unused_result("")));
        [Export("setTitleFont:")]
        STRStoryBuilder SetTitleFont(UIFont font);

        // -(instancetype _Nonnull)setInteractiveFont:(UIFont * _Nullable)font __attribute__((warn_unused_result("")));
        [Export("setInteractiveFont:")]
        STRStoryBuilder SetInteractiveFont([NullAllowed] UIFont font);

        // -(instancetype _Nonnull)setProgressBarColor:(NSArray<UIColor *> * _Nonnull)colors __attribute__((warn_unused_result("")));
        [Export("setProgressBarColor:")]
        STRStoryBuilder SetProgressBarColor(UIColor[] colors);

        // -(instancetype _Nonnull)setTitleVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
        [Export("setTitleVisibility:")]
        STRStoryBuilder SetTitleVisibility(bool isVisible);

        // -(instancetype _Nonnull)setCloseButtonVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
        [Export("setCloseButtonVisibility:")]
        STRStoryBuilder SetCloseButtonVisibility(bool isVisible);

        // -(instancetype _Nonnull)setCloseButtonIcon:(UIImage * _Nullable)icon __attribute__((warn_unused_result("")));
        [Export("setCloseButtonIcon:")]
        STRStoryBuilder SetCloseButtonIcon([NullAllowed] UIImage icon);

        // -(instancetype _Nonnull)setShareButtonIcon:(UIImage * _Nullable)icon __attribute__((warn_unused_result("")));
        [Export("setShareButtonIcon:")]
        STRStoryBuilder SetShareButtonIcon([NullAllowed] UIImage icon);
    }

    // @interface STRConfig : NSObject
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRConfig
    {
    }

    // @interface STRConfigBuilder : NSObject
    [BaseType(typeof(NSObject))]
    interface STRConfigBuilder
    {
        // -(instancetype _Nonnull)setLayoutDirection:(enum StorylyLayoutDirection)direction __attribute__((warn_unused_result("")));
        [Export("setLayoutDirection:")]
        STRConfigBuilder SetLayoutDirection(StorylyLayoutDirection direction);

        // -(instancetype _Nonnull)setCustomParameter:(NSString * _Nullable)parameter __attribute__((warn_unused_result("")));
        [Export("setCustomParameter:")]
        STRConfigBuilder SetCustomParameter([NullAllowed] string parameter);

        // -(instancetype _Nonnull)setLabels:(NSSet<NSString *> * _Nullable)labels __attribute__((warn_unused_result("")));
        [Export("setLabels:")]
        STRConfigBuilder SetLabels([NullAllowed] NSSet<NSString> labels);

        // -(instancetype _Nonnull)setUserData:(NSDictionary<NSString *,NSString *> * _Nonnull)data __attribute__((warn_unused_result("")));
        [Export("setUserData:")]
        STRConfigBuilder SetUserData(NSDictionary<NSString, NSString> data);

        // -(instancetype _Nonnull)setTestMode:(BOOL)isTest __attribute__((warn_unused_result("")));
        [Export("setTestMode:")]
        STRConfigBuilder SetTestMode(bool isTest);

        // -(instancetype _Nonnull)setProductConfig:(StorylyProductConfig * _Nonnull)config __attribute__((warn_unused_result("")));
        [Export("setProductConfig:")]
        STRConfigBuilder SetProductConfig(StorylyProductConfig config);

        // -(instancetype _Nonnull)setShareConfig:(StorylyShareConfig * _Nonnull)config __attribute__((warn_unused_result("")));
        [Export("setShareConfig:")]
        STRConfigBuilder SetShareConfig(StorylyShareConfig config);

        // -(instancetype _Nonnull)setLocale:(NSString * _Nullable)locale __attribute__((warn_unused_result("")));
        [Export("setLocale:")]
        STRConfigBuilder SetLocale([NullAllowed] string locale);

        // -(STRConfigBuilder * _Nonnull)setMute:(BOOL)isMuted __attribute__((warn_unused_result("")));
        [Export("setMute:")]
        STRConfigBuilder SetMute(bool isMuted);
    }
}
