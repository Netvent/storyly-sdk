using Android.App;
using Android.OS;
using Android.Views;
using AndroidX.AppCompat.App;
using Com.Appsamurai.Storyly;
using Com.Appsamurai.Storyly.Config;
using Com.Appsamurai.Storyly.Analytics;
using Com.Appsamurai.Storyly.Config.Styling.Group;
using Android.Content;
using Android.Graphics;
using System.Collections.Generic;
using Android.Util;

namespace xamarin.storyly.demo
{

    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme.NoActionBar", MainLauncher = true)]
    public class MainActivity : AppCompatActivity, IStorylyListener
    {
        protected override void OnCreate(Bundle savedInstanceState)
        {
            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);
            SetContentView(Resource.Layout.activity_main);

            StorylyView storylyView = FindViewById<StorylyView>(Resource.Id.storylyView);
            StorylyView customStorylyView = FindViewById<StorylyView>(Resource.Id.customStorylyView);

            StorylyConfig config = new StorylyConfig.Builder()
                .Build();

            StorylyStoryGroupStyling groupStyling = new StorylyStoryGroupStyling.Builder()
                .SetCustomGroupViewFactory(new CustomStoryViewFactory(this))
                .Build();

            StorylyConfig customStoryConfig = new StorylyConfig.Builder()
                .SetStoryGroupStyling(groupStyling)
               .Build();

            storylyView.StorylyInit = new StorylyInit("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40", config);
            customStorylyView.StorylyInit = new StorylyInit("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40", customStoryConfig);
            storylyView.StorylyListener = this;
        }

        public void StorylyActionClicked(StorylyView storylyView, Story story)
        {
            Log.Info("StorylyListener", story.Media.ActionUrl);
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