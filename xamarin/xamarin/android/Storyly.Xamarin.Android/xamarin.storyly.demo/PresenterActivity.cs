
using AndroidX.AppCompat.App;
using Android.App;
using Android.OS;
using Com.Appsamurai.Storyly.Verticalfeed;
using Com.Appsamurai.Storyly;
using Com.Appsamurai.Storyly.Verticalfeed;
using Com.Appsamurai.Storyly.Config;
using Com.Appsamurai.Storyly.Verticalfeed.Config;
using Com.Appsamurai.Storyly.Analytics;
using Com.Appsamurai.Storyly.Config.Styling.Group;
using Com.Appsamurai.Storyly.Data.Managers.Product;
using Com.Appsamurai.Storyly.Verticalfeed.Listener;
using Android.Views;
using System.Collections.Generic;
using Android.Util;

namespace xamarin.storyly.demo
{
    [Activity(Label = "@string/app_name", Theme = "@style/Theme.AppCompat.Light.NoActionBar", MainLauncher = true)]
    public class PresenterActivity : AppCompatActivity, IStorylyVerticalFeedPresenterListener
    {
        public void verticalFeedPresenterActionClicked(StorylyVerticalFeedPresenterView view, VerticalFeedItem feedItem)
        {
            Log.Info("VerticalFeedActionClicked action clicked", feedItem.ActionUrl);
        }

        public void verticalFeedPresenterDismissed(StorylyVerticalFeedPresenterView view)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedDismissed");
        }

        public void verticalFeedPresenterEvent(StorylyVerticalFeedPresenterView view, VerticalFeedEvent e, VerticalFeedGroup feedGroup, VerticalFeedItem feedItem, VerticalFeedItemComponent feedItemComponent)
        {
            Log.Info("VerticalFeedEvent", e.ToString());
        }

        public void verticalFeedPresenterLoaded(StorylyVerticalFeedPresenterView view, IList<VerticalFeedGroup> feedGroupList, StorylyDataSource dataSource)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedLoaded");
        }

        public void verticalFeedPresenterLoadFailed(StorylyVerticalFeedPresenterView view, string errorMessage)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedLoadFailed");
        }

        public void verticalFeedPresenterShowFailed(StorylyVerticalFeedPresenterView view, string errorMessage)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedShowFailed");
        }

        public void verticalFeedPresenterShown(StorylyVerticalFeedPresenterView view)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedShown");
        }

        public void verticalFeedPresenterUserInteracted(StorylyVerticalFeedPresenterView view, VerticalFeedGroup feedGroup, VerticalFeedItem feedItem, VerticalFeedItemComponent feedItemComponent)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedUserInteracted");
        }

        protected override void OnCreate (Bundle savedInstanceState)
		{
            base.OnCreate(savedInstanceState);
            this.Window.AddFlags(WindowManagerFlags.Fullscreen);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);
            SetContentView(Resource.Layout.vertical_feed_presenter);

            StorylyVerticalFeedPresenterView presenterView = FindViewById<StorylyVerticalFeedPresenterView>(Resource.Id.presenterView);

            StorylyVerticalFeedConfig vfConfig = (StorylyVerticalFeedConfig)new StorylyVerticalFeedConfig.Builder()
              .Build();

            presenterView.StorylyVerticalFeedListener = this;
            presenterView.StorylyVerticalFeedInit = new StorylyVerticalFeedInit("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MjA1MTEsImluc19pZCI6MjI5NDJ9.TXCs-M6guskLJA1JXmu7PlmPxUKfyw88lBpOdxmgpDI", vfConfig);
        }
    }
}

