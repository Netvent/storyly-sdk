using ObjCRuntime;

namespace Storyly
{
	[Native]
	public enum StoryGroupType : long
	{
		Default = 0,
		IVod = 1,
		Ad = 2,
		MomentsDefault = 3,
		MomentsBlock = 4,
		Error = 5
	}

	[Native]
	public enum StoryType : long
	{
		Unknown = 0,
		Image = 1,
		Video = 2,
		Vod = 3,
		Ad = 4
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
		Comment = 13,
		Video = 14,
		Vod = 15,
		LinkCTA = 16
	}

	[Native]
	public enum StorylyDataSource : long
	{
		Api = 0,
		MomentsAPI = 1,
		Local = 2
	}

	[Native]
	public enum StorylyEvent : long
	{
		StoryGroupOpened = 0,
		StoryGroupUserOpened = 1,
		StoryGroupDeepLinkOpened = 2,
		StoryGroupProgrammaticallyOpened = 3,
		StoryGroupCompleted = 4,
		StoryGroupPreviousSwiped = 5,
		StoryGroupNextSwiped = 6,
		StoryGroupClosed = 7,
		StoryImpression = 8,
		StoryViewed = 9,
		StoryCompleted = 10,
		StoryPreviousClicked = 11,
		StoryNextClicked = 12,
		StoryPaused = 13,
		StoryResumed = 14,
		StoryShared = 15,
		StoryCTAClicked = 16,
		StoryEmojiClicked = 17,
		StoryPollAnswered = 18,
		StoryQuizAnswered = 19,
		StoryCountdownReminderAdded = 20,
		StoryCountdownReminderRemoved = 21,
		StoryRated = 22,
		StoryInteractiveImpression = 23,
		StoryProductTagExpanded = 24,
		StoryProductTagClicked = 25,
		StoryProductCardClicked = 26,
		StoryPromoCodeCopied = 27,
		StoryCommentSent = 28,
		StoryCommentInputOpened = 29,
		StoryCommentInputClosed = 30,
		StorylyIVodReplayButtonClicked = 31,
		StorylyIVodSeeked = 32,
		StoryLiked = 33,
		StoryUnliked = 34
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
}
