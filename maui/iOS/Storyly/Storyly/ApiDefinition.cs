using System;
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

		// @property (readonly, copy, nonatomic) NSURL * _Nonnull iconUrl;
		[Export("iconUrl", ArgumentSemantic.Copy)]
		NSUrl IconUrl { get; }

		// @property (readonly, copy, nonatomic) NSURL * _Nullable coverUrl;
		[NullAllowed, Export("coverUrl", ArgumentSemantic.Copy)]
		NSUrl CoverUrl { get; }

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

        // @property (readonly, nonatomic) BOOL nudge;
        [Export("nudge")]
        bool Nudge { get; }

        // @property (readonly, nonatomic, strong) StoryGroupStyle * _Nullable style;
        [NullAllowed, Export("style", ArgumentSemantic.Strong)]
		StoryGroupStyle Style { get; }
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

		// @property (readonly, nonatomic, strong) StoryMedia * _Nonnull media;
		[Export("media", ArgumentSemantic.Strong)]
		StoryMedia Media { get; }
	}

	// @interface StoryMedia : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	interface StoryMedia
	{
		// @property (readonly, nonatomic) enum StoryType type;
		[Export("type")]
		StoryType Type { get; }

		// @property (readonly, copy, nonatomic) NSArray<StoryComponent *> * _Nullable storyComponentList;
		[NullAllowed, Export("storyComponentList", ArgumentSemantic.Copy)]
		StoryComponent[] StoryComponentList { get; }

		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nullable actionUrlList;
		[NullAllowed, Export("actionUrlList", ArgumentSemantic.Copy)]
		string[] ActionUrlList { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable actionUrl;
		[NullAllowed, Export("actionUrl")]
		string ActionUrl { get; }

		// @property (copy, nonatomic) NSURL * _Nullable previewUrl;
		[NullAllowed, Export("previewUrl", ArgumentSemantic.Copy)]
		NSUrl PreviewUrl { get; set; }
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

		// @property (readonly, copy, nonatomic) NSString * _Nullable customPayload;
		[NullAllowed, Export("customPayload")]
		string CustomPayload { get; }
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

		// @property (readonly, copy, nonatomic) NSString * _Nullable customPayload;
		[NullAllowed, Export("customPayload")]
		string CustomPayload { get; }
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

		// @property (readonly, copy, nonatomic) NSString * _Nullable customPayload;
		[NullAllowed, Export("customPayload")]
		string CustomPayload { get; }
	}

	// @interface StoryPromoCodeComponent : StoryComponent
	[BaseType(typeof(StoryComponent))]
	interface StoryPromoCodeComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export("text")]
		string Text { get; }
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

		// @property (readonly, copy, nonatomic) NSString * _Nullable customPayload;
		[NullAllowed, Export("customPayload")]
		string CustomPayload { get; }
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

		// @property (readonly, copy, nonatomic) NSString * _Nullable customPayload;
		[NullAllowed, Export("customPayload")]
		string CustomPayload { get; }
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
    interface STRProductItem: INativeObject
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
    [BaseType(typeof(NSObject))]
    [DisableDefaultCtor]
    interface STRProductVariant
    {
        // @property (readonly, copy, nonatomic) NSString * _Nonnull name;
        [Export("name")]
        string Name { get; }

        // @property (readonly, copy, nonatomic) NSString * _Nonnull value;
        [Export("value")]
        string Value { get; }

        // -(instancetype _Nonnull)initWithName:(NSString * _Nonnull)name value:(NSString * _Nonnull)value __attribute__((objc_designated_initializer));
        [Export("initWithName:value:")]
        [DesignatedInitializer]
        IntPtr Constructor(string name, string value);

        // -(BOOL)isEqual:(id _Nullable)object __attribute__((warn_unused_result("")));
        [Export("isEqual:")]
        bool IsEqual([NullAllowed] NSObject @object);

        // @property (readonly, nonatomic) NSUInteger hash;
        [Export("hash")]
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

	// @interface StorylyConfig : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	interface StorylyConfig
	{
	}

	// @interface StorylyConfigBuilder : NSObject
	[BaseType(typeof(NSObject))]
	interface StorylyConfigBuilder
	{
        // -(StorylyConfigBuilder * _Nonnull)setBarStyling:(StorylyBarStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
        [Export("setBarStyling:")]
        StorylyConfigBuilder SetBarStyling(StorylyBarStyling styling);

		// -(StorylyConfigBuilder * _Nonnull)setStoryStyling:(StorylyStoryStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
		[Export("setStoryStyling:")]
		StorylyConfigBuilder SetStoryStyling(StorylyStoryStyling styling);

		// -(StorylyConfigBuilder * _Nonnull)setStoryGroupStyling:(StorylyStoryGroupStyling * _Nonnull)styling __attribute__((warn_unused_result("")));
		[Export("setStoryGroupStyling:")]
		StorylyConfigBuilder SetStoryGroupStyling(StorylyStoryGroupStyling styling);

		// -(StorylyConfigBuilder * _Nonnull)setLayoutDirection:(enum StorylyLayoutDirection)direction __attribute__((warn_unused_result("")));
		[Export("setLayoutDirection:")]
		StorylyConfigBuilder SetLayoutDirection(StorylyLayoutDirection direction);

		// -(StorylyConfigBuilder * _Nonnull)setCustomParameter:(NSString * _Nullable)parameter __attribute__((warn_unused_result("")));
		[Export("setCustomParameter:")]
		StorylyConfigBuilder SetCustomParameter([NullAllowed] string parameter);

		// -(StorylyConfigBuilder * _Nonnull)setLabels:(NSSet<NSString *> * _Nullable)labels __attribute__((warn_unused_result("")));
		[Export("setLabels:")]
		StorylyConfigBuilder SetLabels([NullAllowed] NSSet<NSString> labels);

		// -(StorylyConfigBuilder * _Nonnull)setUserData:(NSDictionary<NSString *,NSString *> * _Nonnull)data __attribute__((warn_unused_result("")));
		[Export("setUserData:")]
		StorylyConfigBuilder SetUserData(NSDictionary<NSString, NSString> data);

		// -(StorylyConfigBuilder * _Nonnull)setTestMode:(BOOL)isTest __attribute__((warn_unused_result("")));
		[Export("setTestMode:")]
		StorylyConfigBuilder SetTestMode(bool isTest);

        // -(StorylyConfigBuilder * _Nonnull)setProductConfig:(StorylyProductConfig * _Nonnull)config __attribute__((warn_unused_result("")));
        [Export("setProductConfig:")]
        StorylyConfigBuilder SetProductConfig(StorylyProductConfig config);

        // -(StorylyConfigBuilder * _Nonnull)setShareConfig:(StorylyShareConfig * _Nonnull)config __attribute__((warn_unused_result("")));
        [Export("setShareConfig:")]
		StorylyConfigBuilder SetShareConfig(StorylyShareConfig config);

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

	// @interface StorylyStoryStyling : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	interface StorylyStoryStyling
	{
	}

	// @interface StorylyStoryStylingBuilder : NSObject
	[BaseType(typeof(NSObject))]
	interface StorylyStoryStylingBuilder
	{
		// -(StorylyStoryStylingBuilder * _Nonnull)setHeaderIconBorderColor:(NSArray<UIColor *> * _Nonnull)colors __attribute__((warn_unused_result("")));
		[Export("setHeaderIconBorderColor:")]
		StorylyStoryStylingBuilder SetHeaderIconBorderColor(UIColor[] colors);

		// -(StorylyStoryStylingBuilder * _Nonnull)setTitleColor:(UIColor * _Nonnull)color __attribute__((warn_unused_result("")));
		[Export("setTitleColor:")]
		StorylyStoryStylingBuilder SetTitleColor(UIColor color);

		// -(StorylyStoryStylingBuilder * _Nonnull)setTitleFont:(UIFont * _Nonnull)font __attribute__((warn_unused_result("")));
		[Export("setTitleFont:")]
		StorylyStoryStylingBuilder SetTitleFont(UIFont font);

		// -(StorylyStoryStylingBuilder * _Nonnull)setInteractiveFont:(UIFont * _Nonnull)font __attribute__((warn_unused_result("")));
		[Export("setInteractiveFont:")]
		StorylyStoryStylingBuilder SetInteractiveFont(UIFont font);

		// -(StorylyStoryStylingBuilder * _Nonnull)setProgressBarColor:(NSArray<UIColor *> * _Nonnull)colors __attribute__((warn_unused_result("")));
		[Export("setProgressBarColor:")]
		StorylyStoryStylingBuilder SetProgressBarColor(UIColor[] colors);

		// -(StorylyStoryStylingBuilder * _Nonnull)setTitleVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
		[Export("setTitleVisibility:")]
		StorylyStoryStylingBuilder SetTitleVisibility(bool isVisible);

		// -(StorylyStoryStylingBuilder * _Nonnull)setHeaderIconVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
		[Export("setHeaderIconVisibility:")]
		StorylyStoryStylingBuilder SetHeaderIconVisibility(bool isVisible);

		// -(StorylyStoryStylingBuilder * _Nonnull)setCloseButtonVisibility:(BOOL)isVisible __attribute__((warn_unused_result("")));
		[Export("setCloseButtonVisibility:")]
		StorylyStoryStylingBuilder SetCloseButtonVisibility(bool isVisible);

		// -(StorylyStoryStylingBuilder * _Nonnull)setCloseButtonIcon:(UIImage * _Nullable)icon __attribute__((warn_unused_result("")));
		[Export("setCloseButtonIcon:")]
		StorylyStoryStylingBuilder SetCloseButtonIcon([NullAllowed] UIImage icon);

		// -(StorylyStoryStylingBuilder * _Nonnull)setShareButtonIcon:(UIImage * _Nullable)icon __attribute__((warn_unused_result("")));
		[Export("setShareButtonIcon:")]
		StorylyStoryStylingBuilder SetShareButtonIcon([NullAllowed] UIImage icon);

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
        StorylyProductConfig Build { get; }
    }
}
