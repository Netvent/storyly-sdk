using ObjCRuntime;

namespace Storyly
{
    [Native]
    public enum PlayMode : long
    {
        Default = 0,
        StoryGroup = 1,
        Story = 2
    }

    [Native]
    public enum ShareType : long
    {
        Disabled = 0,
        Link = 1,
        Screenshot = 2
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
    public enum StoryGroupSize : long
    {
        Small = 0,
        Large = 1,
        Custom = 2
    }

    [Native]
    public enum StoryGroupType : long
    {
        Default = 0,
        Ad = 1,
        Live = 2,
        AutomatedShoppable = 3
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
        Liked = 16,
        CTAClicked = 17,
        EmojiClicked = 18,
        PollAnswered = 19,
        QuizAnswered = 20,
        ImageQuizAnswered = 21,
        CountdownReminderAdded = 22,
        CountdownReminderRemoved = 23,
        Rated = 24,
        InteractiveImpression = 25,
        ProductTagExpanded = 26,
        ButtonActionClicked = 27,
        ImageButtonActionClicked = 28,
        SwipeActionClicked = 29,
        ProductTagClicked = 30,
        ProductCardClicked = 31,
        ProductCatalogClicked = 32,
        PromoCodeCopied = 33,
        CommentSent = 34,
        CommentInputOpened = 35,
        CommentInputClosed = 36,
        Seeked = 37,
        ProductCartAdded = 38,
        ProductCartAddFailed = 39,
        ProductSheetOpened = 40,
        ProductAdded = 41,
        ProductUpdated = 42,
        ProductRemoved = 43,
        CheckoutButtonClicked = 44,
        CartButtonClicked = 45,
        CartViewClicked = 46,
        ProductSelected = 47
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
        ItemButtonActionClicked = 27,
        ItemImageButtonActionClicked = 28,
        ItemSwipeActionClicked = 29,
        ItemProductTagClicked = 30,
        ItemProductCardClicked = 31,
        ItemProductCatalogClicked = 32,
        ItemPromoCodeCopied = 33,
        ItemCommentSent = 34,
        ItemCommentInputOpened = 35,
        ItemCommentInputClosed = 36,
        ItemSeeked = 37,
        ItemProductCartAdded = 38,
        ItemProductCartAddFailed = 39,
        ItemProductSheetOpened = 40,
        ItemProductAdded = 41,
        ItemProductUpdated = 42,
        ItemProductRemoved = 43,
        ItemCheckoutButtonClicked = 44,
        ItemCartButtonClicked = 45,
        ItemCartViewClicked = 46,
        ItemProductSelected = 47
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
