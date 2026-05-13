using Android.App;
using Android.OS;
using Android.Views;
using AndroidX.AppCompat.App;
using Com.Appsamurai.Storyly;
using Com.Appsamurai.Storyly.Verticalfeed;
using Com.Appsamurai.Storyly.Config;
using Com.Appsamurai.Storyly.Verticalfeed.Config;
using Com.Appsamurai.Storyly.Analytics;
using Com.Appsamurai.Storyly.Verticalfeed.Listener;
using Com.Appsamurai.Storyly.Config.Styling.Group;
using Android.Content;
using Android.Graphics;
using System.Collections.Generic;
using Android.Util;
using Com.Appsamurai.Storyly.Verticalfeed.Config.Bar;
using Android.Widget;
using Com.Appsamurai.Storyly.Verticalfeed.Core;

namespace xamarin.storyly.demo
{

    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme.NoActionBar", MainLauncher = true)]
    public class MainActivity : AppCompatActivity, IStorylyListener, IStorylyVerticalFeedListener
    {
        protected override void OnCreate(Bundle savedInstanceState)
        {
            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);
            SetContentView(Resource.Layout.activity_main);

            //Setup StorylyView
            StorylyView storylyView = FindViewById<StorylyView>(Resource.Id.storylyView);
            StorylyConfig config = (StorylyConfig)new StorylyConfig.Builder()
               .Build();
            storylyView.StorylyInit = new StorylyInit("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MjA1MTEsImluc19pZCI6MjI5NDJ9.TXCs-M6guskLJA1JXmu7PlmPxUKfyw88lBpOdxmgpDI", config);
            storylyView.StorylyListener = this;

            //Setup CustomStorylyView
            StorylyView customStorylyView = FindViewById<StorylyView>(Resource.Id.customStorylyView);
            StorylyStoryGroupStyling groupStyling = new StorylyStoryGroupStyling.Builder()
                .SetCustomGroupViewFactory(new CustomStoryViewFactory(this))
                .Build();
            StorylyConfig customStoryConfig = (StorylyConfig)new StorylyConfig.Builder()
                .SetStoryGroupStyling(groupStyling)
               .Build();
            customStorylyView.StorylyInit = new StorylyInit("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MjA1MTEsImluc19pZCI6MjI5NDJ9.TXCs-M6guskLJA1JXmu7PlmPxUKfyw88lBpOdxmgpDI", customStoryConfig);


            //Setup StorylyVerticalFeedBarView
            StorylyVerticalFeedBarView verticalFeedBarView = FindViewById<StorylyVerticalFeedBarView>(Resource.Id.vfBarView);
            StorylyVerticalFeedConfig vfBarConfig = (StorylyVerticalFeedConfig)new StorylyVerticalFeedConfig.Builder()
               .Build();
            verticalFeedBarView.StorylyVerticalFeedInit = new StorylyVerticalFeedInit("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MjA1MTEsImluc19pZCI6MjI5NDJ9.TXCs-M6guskLJA1JXmu7PlmPxUKfyw88lBpOdxmgpDI", vfBarConfig);
            verticalFeedBarView.StorylyVerticalFeedListener = this;

            //Setup StorylyVerticalFeedView
            StorylyVerticalFeedView vericalFeedView = FindViewById<StorylyVerticalFeedView>(Resource.Id.vfView);
            StorylyVerticalFeedBarStyling vfGroupStyle = (StorylyVerticalFeedBarStyling)new StorylyVerticalFeedBarStyling.Builder()
               .SetSection(2)
              .Build();
            StorylyVerticalFeedConfig vfConfig = (StorylyVerticalFeedConfig)new StorylyVerticalFeedConfig.Builder()
                .SetVerticalFeedBarStyling(vfGroupStyle)
               .Build();
            vericalFeedView.StorylyVerticalFeedInit = new StorylyVerticalFeedInit("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MjA1MTEsImluc19pZCI6MjI5NDJ9.TXCs-M6guskLJA1JXmu7PlmPxUKfyw88lBpOdxmgpDI", vfConfig);
            vericalFeedView.StorylyVerticalFeedListener = this;

            //Setup Button
            Button button = FindViewById<Button>(Resource.Id.presenterButton);
            button.Click += delegate
            {
                var intent = new Intent(this, typeof(PresenterActivity));
                this.StartActivity(intent);
            }; 
        }

        public void StorylyActionClicked(StorylyView storylyView, Story story)
        {
            Log.Info("StorylyListener action clicked", story.ActionUrl);
        }

        public void StorylyEvent(StorylyView storylyView, StorylyEvent e, StoryGroup storyGroup, Story story, StoryComponent storyComponent)
        {
            Log.Info("StorylyListener", e.ToString());
        }

        public void StorylyLoadFailed(StorylyView storylyView, string errorMessage)
        {
            Log.Info("StorylyListener", "StorylyLoadFailed");
        }

        public void StorylyLoaded(StorylyView storylyView, IList<StoryGroup> storyGroupList, StorylyDataSource dataSource)
        {
            Log.Info("StorylyListener", "StorylyLoaded");
        }

        public void StorylyStoryDismissed(StorylyView storylyView)
        {
            Log.Info("StorylyListener", "StorylyStoryDismissed");
        }

        public void StorylyStoryShowFailed(StorylyView storylyView, string errorMessage)
        {
            Log.Info("StorylyListener", "StorylyStoryShowFailed");
        }

        public void StorylyStoryShown(StorylyView storylyView)
        {
            Log.Info("StorylyListener", "StorylyStoryShown");
        }

        public void StorylyUserInteracted(StorylyView storylyView, StoryGroup storyGroup, Story story, StoryComponent storyComponent)
        {
            Log.Info("StorylyListener", "StorylyUserInteracted");
        }

        public void StorylySizeChanged(StorylyView storylyView, Kotlin.Pair size)
        {
            Log.Info("StorylyListener", "StorylySizeChanged");
        }

        public void VerticalFeedActionClicked(STRVerticalFeedView view, VerticalFeedItem feedItem)
        {
            Log.Info("VerticalFeedActionClicked action clicked", feedItem.ActionUrl);
        }

        public void VerticalFeedDismissed(STRVerticalFeedView view)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedDismissed");
        }

        public void VerticalFeedEvent(STRVerticalFeedView view, VerticalFeedEvent e, VerticalFeedGroup feedGroup, VerticalFeedItem feedItem, VerticalFeedItemComponent feedItemComponent)
        {
            Log.Info("VerticalFeedEvent", e.ToString());
        }

        public void VerticalFeedLoadFailed(STRVerticalFeedView view, string errorMessage)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedLoadFailed");
        }

        public void VerticalFeedLoaded(STRVerticalFeedView view, IList<VerticalFeedGroup> feedGroupList, StorylyDataSource dataSource)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedLoaded");
        }

        public void VerticalFeedShowFailed(STRVerticalFeedView view, string errorMessage)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedShowFailed");
        }

        public void VerticalFeedShown(STRVerticalFeedView view)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedShown");
        }

        public void VerticalFeedUserInteracted(STRVerticalFeedView view, VerticalFeedGroup feedGroup, VerticalFeedItem feedItem, VerticalFeedItemComponent feedItemComponent)
        {
            Log.Info("VerticalFeedListener", "VerticalFeedUserInteracted");
        }
    }
}


public class CustomStoryView : StoryGroupView
{

    public CustomStoryView(Context context) : base(context)
    {
        View view = new View(context);
        AddView(view, new LayoutParams(250, 250));
    }

    public override void PopulateView(StoryGroup storyGroup)
    {
        if (storyGroup?.Seen == true)
        {
            SetBackgroundColor(Color.Red);
        }
        else
        {
            SetBackgroundColor(Color.Blue);
        }
    }
}

public class CustomStoryViewFactory : StoryGroupViewFactory
{
    private readonly Context context;

    public CustomStoryViewFactory(Context context)
    {
        this.context = context;
    }

    public override StoryGroupView CreateView()
    {
        return new CustomStoryView(context);
    }
}