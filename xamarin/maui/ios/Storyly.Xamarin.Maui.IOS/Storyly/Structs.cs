using ObjCRuntime;

namespace Storyly
{
	[Native]
	public enum StorylyDataSource : long
	{
		Api = 0,
		Local = 1
	}

	[Native]
	public enum StorylyEvent : long
	{
		GroupOpened = 0,
		GroupUserOpened = 1,
		GroupDeepLinkOpened = 2,
		GroupProgrammaticallyOpened = 3,
		GroupCompleted = 4,
		GroupPreviousSwiped = 5,
		GroupNextSwiped = 6,
		GroupClosed = 7,
		Impression = 8,
		Viewed = 9,
		Completed = 10,
		PreviousClicked = 11,
		NextClicked = 12,
		Paused = 13,
		Resumed = 14,
		Shared = 15,
		CTAClicked = 16,
		EmojiClicked = 17,
		PollAnswered = 18,
		QuizAnswered = 19,
		ImageQuizAnswered = 20,
		CountdownReminderAdded = 21,
		CountdownReminderRemoved = 22,
		Rated = 23,
		InteractiveImpression = 24,
		ProductTagExpanded = 25,
		ProductTagClicked = 26,
		ProductCardClicked = 27,
		ProductCatalogClicked = 28,
		PromoCodeCopied = 29,
		CommentSent = 30,
		CommentInputOpened = 31,
		CommentInputClosed = 32,
		Seeked = 33,
		Liked = 34,
		Unliked = 35,
		ProductCartAdded = 36,
		ProductCartAddFailed = 37,
		ProductSheetOpened = 38,
		ProductAdded = 39,
		ProductUpdated = 40,
		ProductRemoved = 41,
		CheckoutButtonClicked = 42,
		CartButtonClicked = 43,
		CartViewClicked = 44,
		ProductSelected = 45
	}

	[Native]
	public enum StoryGroupType : long
	{
		Default = 0,
		Ad = 1,
		MomentsDefault = 2,
		MomentsBlock = 3,
		Live = 4,
		AutomatedShoppable = 5
	}

	[Native]
	public enum StoryType : long
	{
		Unknown = 0,
		Image = 1,
		Video = 2,
		LongVideo = 3,
		Live = 4,
		Ad = 5
	}

	[Native]
	public enum StoryComponentType : long
	{
		Undefined = 0,
		Quiz = 1,
		Poll = 2,
		Emoji = 3,
		Rating = 4,
		PromoCode = 5,
		SwipeAction = 6,
		ButtonAction = 7,
		Text = 8,
		Image = 9,
		Countdown = 10,
		ProductTag = 11,
		ProductCard = 12,
		ProductCatalog = 13,
		Comment = 14,
		Video = 15,
		LongVideo = 16,
		LinkCTA = 17,
		ImageQuiz = 18
	}
}

namespace Storyly
{
	[Native]
	public enum StoryGroupSize : long
	{
		Small = 0,
		Large = 1,
		Custom = 2
	}

	[Native]
	public enum StoryGroupAnimation : long
	{
		Disabled = 0,
		BorderRotation = 1
	}

	[Native]
	public enum StoryGroupListOrientation : long
	{
		Horizontal = 0,
		Vertical = 1
	}

	[Native]
	public enum StorylyLayoutDirection : long
	{
		Ltr = 0,
		Rtl = 1
	}

	[Native]
	public enum VerticalFeedGroupOrder : long
	{
		Static = 0,
		BySeenState = 1
	}

	[Native]
	public enum VerticalFeedEvent : long
	{
		GroupOpened = 0,
		GroupUserOpened = 1,
		GroupDeepLinkOpened = 2,
		GroupProgrammaticallyOpened = 3,
		GroupCompleted = 4,
		GroupPreviousSwiped = 5,
		GroupNextSwiped = 6,
		GroupClosed = 7,
		ItemImpression = 8,
		ItemViewed = 9,
		ItemCompleted = 10,
		ItemPreviousClicked = 11,
		ItemNextClicked = 12,
		ItemPaused = 13,
		ItemResumed = 14,
		ItemShared = 15,
		ItemLiked = 16,
		ItemCTAClicked = 17,
		ItemEmojiClicked = 18,
		ItemPollAnswered = 19,
		ItemQuizAnswered = 20,
		ItemImageQuizAnswered = 21,
		ItemCountdownReminderAdded = 22,
		ItemCountdownReminderRemoved = 23,
		ItemRated = 24,
		ItemInteractiveImpression = 25,
		ItemProductTagExpanded = 26,
		ItemProductTagClicked = 27,
		ItemProductCardClicked = 28,
		ItemProductCatalogClicked = 29,
		ItemPromoCodeCopied = 30,
		ItemCommentSent = 31,
		ItemCommentInputOpened = 32,
		ItemCommentInputClosed = 33,
		ItemSeeked = 34,
		ItemProductCartAdded = 35,
		ItemProductCartAddFailed = 36,
		ItemProductSheetOpened = 37,
		ItemProductAdded = 38,
		ItemProductUpdated = 39,
		ItemProductRemoved = 40,
		ItemCheckoutButtonClicked = 41,
		ItemCartButtonClicked = 42,
		ItemCartViewClicked = 43,
		ItemProductSelected = 44
	}

	[Native]
	public enum VerticalFeedGroupAnimation : long
	{
		Disabled = 0,
		BorderRotation = 1
	}

	[Native]
	public enum VerticalFeedGroupListOrientation : long
	{
		Horizontal = 0,
		Vertical = 1
	}

	[Native]
	public enum VerticalFeedGroupSize : long
	{
		Small = 0,
		Large = 1,
		Custom = 2
	}

	[Native]
	public enum VerticalFeedGroupType : long
	{
		Default = 0,
		Ad = 1,
		Live = 2,
		AutomatedShoppable = 3
	}

	[Native]
	public enum VerticalFeedItemComponentType : long
	{
		Undefined = 0,
		Quiz = 1,
		Poll = 2,
		Emoji = 3,
		Rating = 4,
		PromoCode = 5,
		SwipeAction = 6,
		ButtonAction = 7,
		Text = 8,
		Image = 9,
		Countdown = 10,
		ProductTag = 11,
		ProductCard = 12,
		ProductCatalog = 13,
		Comment = 14,
		Video = 15,
		LongVideo = 16,
		LinkCTA = 17,
		ImageQuiz = 18
	}

	[Native]
	public enum VerticalFeedType : long
	{
		Unknown = 0,
		Image = 1,
		Video = 2,
		LongVideo = 3,
		Live = 4,
		Ad = 5
	}
}
