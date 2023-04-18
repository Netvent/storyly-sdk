using System;
using CoreGraphics;
using Foundation;
using ObjCRuntime;
using UIKit;

namespace Storyly
{
	// @interface StorylyInit : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	[Protocol]
	interface StorylyInit
	{
		// @property (nonatomic, strong) StorylySegmentation * _Nonnull segmentation;
		[Export("segmentation", ArgumentSemantic.Strong)]
		StorylySegmentation Segmentation { get; set; }

		// @property (copy, nonatomic) NSDictionary<NSString *,NSString *> * _Nonnull userData;
		[Export("userData", ArgumentSemantic.Copy)]
		NSDictionary<NSString, NSString> UserData { get; set; }

		// -(instancetype _Nonnull)initWithStorylyId:(NSString * _Nonnull)storylyId __attribute__((objc_designated_initializer));
		[Export("initWithStorylyId:")]
		[DesignatedInitializer]
		IntPtr Constructor(string storylyId);

		// -(instancetype _Nonnull)initWithStorylyId:(NSString * _Nonnull)storylyId segmentation:(StorylySegmentation * _Nonnull)segmentation customParameter:(NSString * _Nullable)customParameter isTestMode:(BOOL)isTestMode storylyPayload:(NSString * _Nullable)storylyPayload userData:(NSDictionary<NSString *,NSString *> * _Nonnull)userData __attribute__((objc_designated_initializer));
		[Export("initWithStorylyId:segmentation:customParameter:isTestMode:storylyPayload:userData:")]
		[DesignatedInitializer]
		IntPtr Constructor(string storylyId, StorylySegmentation segmentation, [NullAllowed] string customParameter, bool isTestMode, [NullAllowed] string storylyPayload, NSDictionary<NSString, NSString> userData);
	}

	// @interface StorylySegmentation : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	[Protocol]
	interface StorylySegmentation
	{
		// -(instancetype _Nonnull)initWithSegments:(NSSet<NSString *> * _Nullable)segments __attribute__((objc_designated_initializer));
		[Export("initWithSegments:")]
		[DesignatedInitializer]
		IntPtr Constructor([NullAllowed] NSSet<NSString> segments);
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

		// @property (readonly, copy, nonatomic) NSDictionary<NSString *,NSURL *> * _Nullable thematicIconUrls;
		[NullAllowed, Export("thematicIconUrls", ArgumentSemantic.Copy)]
		NSDictionary<NSString, NSUrl> ThematicIconUrls { get; }

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

		// TODO: check constructor
		//// -(instancetype _Nonnull)initWithGroupTheme:(NSString * _Nullable)groupTheme id:(NSString * _Nonnull)id title:(NSString * _Nonnull)title iconUrl:(NSURL * _Nonnull)iconUrl thematicIconUrls:(NSDictionary<NSString *,NSURL *> * _Nullable)thematicIconUrls coverUrl:(NSURL * _Nullable)coverUrl index:(NSInteger)index seen:(BOOL)seen stories:(NSArray<Story *> * _Nonnull)stories pinned:(BOOL)pinned type:(enum StoryGroupType)type momentsUser:(MomentsUser * _Nullable)momentsUser __attribute__((objc_designated_initializer));
		//[Export("initWithGroupTheme:id:title:iconUrl:thematicIconUrls:coverUrl:index:seen:stories:pinned:type:momentsUser:")]
		//[DesignatedInitializer]
		//IntPtr Constructor([NullAllowed] string groupTheme, string id, string title, NSUrl iconUrl, [NullAllowed] NSDictionary<NSString, NSUrl> thematicIconUrls, [NullAllowed] NSUrl coverUrl, nint index, bool seen, Story[] stories, bool pinned, StoryGroupType type, [NullAllowed] MomentsUser momentsUser);
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

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id index:(NSInteger)index title:(NSString * _Nonnull)title name:(NSString * _Nullable)name seen:(BOOL)seen currentTime:(NSInteger)currentTime media:(StoryMedia * _Nonnull)media __attribute__((objc_designated_initializer));
		[Export("initWithId:index:title:name:seen:currentTime:media:")]
		[DesignatedInitializer]
		IntPtr Constructor(string id, nint index, string title, [NullAllowed] string name, bool seen, nint currentTime, StoryMedia media);
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

		// -(instancetype _Nonnull)initWithType:(enum StoryType)type storyComponentList:(NSArray<StoryComponent *> * _Nullable)storyComponentList actionUrlList:(NSArray<NSString *> * _Nullable)actionUrlList actionUrl:(NSString * _Nullable)actionUrl previewUrl:(NSURL * _Nullable)previewUrl __attribute__((objc_designated_initializer));
		[Export("initWithType:storyComponentList:actionUrlList:actionUrl:previewUrl:")]
		[DesignatedInitializer]
		IntPtr Constructor(StoryType type, [NullAllowed] StoryComponent[] storyComponentList, [NullAllowed] string[] actionUrlList, [NullAllowed] string actionUrl, [NullAllowed] NSUrl previewUrl);
	}

	// TODO: add childs of StoryComponent
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

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text __attribute__((objc_designated_initializer));
		[Export("initWithId:text:")]
		[DesignatedInitializer]
		IntPtr Constructor(string id, string text);
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

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id emojiCodes:(NSArray<NSString *> * _Nonnull)emojiCodes selectedEmojiIndex:(NSInteger)selectedEmojiIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export("initWithId:emojiCodes:selectedEmojiIndex:customPayload:")]
		[DesignatedInitializer]
		IntPtr Constructor(string id, string[] emojiCodes, nint selectedEmojiIndex, [NullAllowed] string customPayload);
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

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nonnull)options selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export("initWithId:title:options:selectedOptionIndex:customPayload:")]
		[DesignatedInitializer]
		IntPtr Constructor(string id, string title, string[] options, nint selectedOptionIndex, [NullAllowed] string customPayload);
	}

	// @interface StoryPromoCodeComponent : StoryComponent
	[BaseType(typeof(StoryComponent))]
	interface StoryPromoCodeComponent
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull text;
		[Export("text")]
		string Text { get; }

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id text:(NSString * _Nonnull)text __attribute__((objc_designated_initializer));
		[Export("initWithId:text:")]
		[DesignatedInitializer]
		IntPtr Constructor(string id, string text);
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

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id title:(NSString * _Nonnull)title options:(NSArray<NSString *> * _Nonnull)options rightAnswerIndex:(NSNumber * _Nullable)rightAnswerIndex selectedOptionIndex:(NSInteger)selectedOptionIndex customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export("initWithId:title:options:rightAnswerIndex:selectedOptionIndex:customPayload:")]
		[DesignatedInitializer]
		IntPtr Constructor(string id, string title, string[] options, [NullAllowed] NSNumber rightAnswerIndex, nint selectedOptionIndex, [NullAllowed] string customPayload);
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

		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id emojiCode:(NSString * _Nonnull)emojiCode rating:(NSInteger)rating customPayload:(NSString * _Nullable)customPayload __attribute__((objc_designated_initializer));
		[Export("initWithId:emojiCode:rating:customPayload:")]
		[DesignatedInitializer]
		IntPtr Constructor(string id, string emojiCode, nint rating, [NullAllowed] string customPayload);
	}

	// @protocol StorylyDelegate
	[BaseType(typeof(NSObject))]
	[Protocol, Model(AutoGeneratedName = true)]
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

	// @interface StoryGroupIconStyling : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	interface StoryGroupIconStyling
	{
		// @property (nonatomic) CGFloat height;
		[Export("height")]
		nfloat Height { get; set; }

		// @property (nonatomic) CGFloat width;
		[Export("width")]
		nfloat Width { get; set; }

		// @property (nonatomic) CGFloat cornerRadius;
		[Export("cornerRadius")]
		nfloat CornerRadius { get; set; }

		// -(instancetype _Nonnull)initWithHeight:(CGFloat)height width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius __attribute__((objc_designated_initializer));
		[Export("initWithHeight:width:cornerRadius:")]
		[DesignatedInitializer]
		IntPtr Constructor(nfloat height, nfloat width, nfloat cornerRadius);
	}

	// @interface StoryGroupListStyling : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	interface StoryGroupListStyling
	{
		// @property (nonatomic) enum StoryGroupListOrientation orientation;
		[Export("orientation", ArgumentSemantic.Assign)]
		StoryGroupListOrientation Orientation { get; set; }

		// @property (nonatomic) NSInteger sections;
		[Export("sections")]
		nint Sections { get; set; }

		// @property (nonatomic) CGFloat horizontalEdgePadding;
		[Export("horizontalEdgePadding")]
		nfloat HorizontalEdgePadding { get; set; }

		// @property (nonatomic) CGFloat verticalEdgePadding;
		[Export("verticalEdgePadding")]
		nfloat VerticalEdgePadding { get; set; }

		// @property (nonatomic) CGFloat horizontalPaddingBetweenItems;
		[Export("horizontalPaddingBetweenItems")]
		nfloat HorizontalPaddingBetweenItems { get; set; }

		// @property (nonatomic) CGFloat verticalPaddingBetweenItems;
		[Export("verticalPaddingBetweenItems")]
		nfloat VerticalPaddingBetweenItems { get; set; }

		// -(instancetype _Nonnull)initWithOrientation:(enum StoryGroupListOrientation)orientation sections:(NSInteger)sections horizontalEdgePadding:(CGFloat)horizontalEdgePadding verticalEdgePadding:(CGFloat)verticalEdgePadding horizontalPaddingBetweenItems:(CGFloat)horizontalPaddingBetweenItems verticalPaddingBetweenItems:(CGFloat)verticalPaddingBetweenItems __attribute__((objc_designated_initializer));
		[Export("initWithOrientation:sections:horizontalEdgePadding:verticalEdgePadding:horizontalPaddingBetweenItems:verticalPaddingBetweenItems:")]
		[DesignatedInitializer]
		IntPtr Constructor(StoryGroupListOrientation orientation, nint sections, nfloat horizontalEdgePadding, nfloat verticalEdgePadding, nfloat horizontalPaddingBetweenItems, nfloat verticalPaddingBetweenItems);
	}

	// @interface StoryGroupTextStyling : NSObject
	[BaseType(typeof(NSObject))]
	[DisableDefaultCtor]
	interface StoryGroupTextStyling
	{
		// @property (nonatomic) BOOL isVisible;
		[Export("isVisible")]
		bool IsVisible { get; set; }

		// @property (nonatomic, strong) UIColor * _Nonnull colorSeen;
		[Export("colorSeen", ArgumentSemantic.Strong)]
		UIColor ColorSeen { get; set; }

		// @property (nonatomic, strong) UIColor * _Nonnull colorNotSeen;
		[Export("colorNotSeen", ArgumentSemantic.Strong)]
		UIColor ColorNotSeen { get; set; }

		// @property (nonatomic, strong) UIFont * _Nullable font;
		[NullAllowed, Export("font", ArgumentSemantic.Strong)]
		UIFont Font { get; set; }

		// @property (nonatomic) NSInteger lines;
		[Export("lines")]
		nint Lines { get; set; }

		// -(instancetype _Nonnull)initWithIsVisible:(BOOL)isVisible colorSeen:(UIColor * _Nonnull)colorSeen colorNotSeen:(UIColor * _Nonnull)colorNotSeen font:(UIFont * _Nullable)font lines:(NSInteger)lines __attribute__((objc_designated_initializer));
		[Export("initWithIsVisible:colorSeen:colorNotSeen:font:lines:")]
		[DesignatedInitializer]
		IntPtr Constructor(bool isVisible, UIColor colorSeen, UIColor colorNotSeen, [NullAllowed] UIFont font, nint lines);
	}

	// TODO: add pause/resume and PresentWithAnimated/DismissWithAnimated
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

		// -(void)pause;
		[Export("pause")]
		void Pause();

		// -(void)resume;
		[Export("resume")]
		void Resume();

		// -(void)presentWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
		[Export("presentWithAnimated:completion:")]
		void PresentWithAnimated(bool animated, [NullAllowed] Action completion);

		// -(void)dismissWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
		[Export("dismissWithAnimated:completion:")]
		void DismissWithAnimated(bool animated, [NullAllowed] Action completion);

		// -(BOOL)setExternalData:(NSArray<NSDictionary *> * _Nonnull)externalData __attribute__((warn_unused_result("")));
		[Export("setExternalData:")]
		bool SetExternalData(NSDictionary[] externalData);

		// @property (copy, nonatomic) NSString * _Nonnull storyGroupAnimation;
		[Export("storyGroupAnimation")]
		string StoryGroupAnimation { get; set; }

		// @property (copy, nonatomic) NSString * _Nonnull storyGroupSize;
		[Export("storyGroupSize")]
		string StoryGroupSize { get; set; }

		// @property (nonatomic, strong) StoryGroupIconStyling * _Nonnull storyGroupIconStyling;
		[Export("storyGroupIconStyling", ArgumentSemantic.Strong)]
		StoryGroupIconStyling StoryGroupIconStyling { get; set; }

		// @property (copy, nonatomic) NSArray<UIColor *> * _Nonnull storyGroupIconBorderColorSeen;
		[Export("storyGroupIconBorderColorSeen", ArgumentSemantic.Copy)]
		UIColor[] StoryGroupIconBorderColorSeen { get; set; }

		// @property (copy, nonatomic) NSArray<UIColor *> * _Nonnull storyGroupIconBorderColorNotSeen;
		[Export("storyGroupIconBorderColorNotSeen", ArgumentSemantic.Copy)]
		UIColor[] StoryGroupIconBorderColorNotSeen { get; set; }

		// @property (nonatomic, strong) UIColor * _Nonnull storyGroupIconBackgroundColor;
		[Export("storyGroupIconBackgroundColor", ArgumentSemantic.Strong)]
		UIColor StoryGroupIconBackgroundColor { get; set; }

		// @property (nonatomic, strong) StoryGroupListStyling * _Nonnull storyGroupListStyling;
		[Export("storyGroupListStyling", ArgumentSemantic.Strong)]
		StoryGroupListStyling StoryGroupListStyling { get; set; }

		// @property (nonatomic, strong) StoryGroupTextStyling * _Nonnull storyGroupTextStyling;
		[Export("storyGroupTextStyling", ArgumentSemantic.Strong)]
		StoryGroupTextStyling StoryGroupTextStyling { get; set; }

		// -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
		[Export("initWithFrame:")]
		[DesignatedInitializer]
		IntPtr Constructor(CGRect frame);
	}
}
