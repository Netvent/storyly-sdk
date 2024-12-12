module.exports = {
    get Storyly() {
        return require('./RNStoryly').default;
    },
    get VerticalFeedBar() {
        return require('./RNVerticalFeedBar').default;
    },
    get VerticalFeed() {
        return require('./RNVerticalFeed').default;
    },
    get VerticalFeedPresenter() {
        return require('./RNVerticalFeedPresenter').default;
    }
}
