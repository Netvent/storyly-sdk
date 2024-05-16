using System;
using CoreGraphics;
using UIKit;

namespace Storyly.Xamarin.iOS.Demo
{
    static class Constants
    {
        public const string StorylyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjU4OTMsImFwcF9pZCI6MTc1MTMsImluc19pZCI6MTk1MzV9.RzvLM7KNF01AgOYzOfgJoafr6cSB9kc1DmJ6U14A3XQ";
    }

    public partial class ViewController : UIViewController
    {
        public ViewController(IntPtr handle) : base(handle)
        {
        }

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // Perform any additional setup after loading the view, typically from a nib.

            var storylyView = new StorylyView(new CGRect(0, 50, 414, 90))
            {
                StorylyInit = new StorylyInit(
                    Constants.StorylyToken,
                    new StorylyConfigBuilder()
                    .Build()),
                RootViewController = this,
                Delegate = new StorylyDelegateImpl()
            };
            View.AddSubview(storylyView);

            var storylyViewCustomization = new StorylyView(new CGRect(0, 180, 414, 130))
            {
                StorylyInit = new StorylyInit(
                    Constants.StorylyToken,
                    new StorylyConfigBuilder()
                        .SetStoryGroupStyling(new StorylyStoryGroupStylingBuilder().SetSize(StoryGroupSize.Small)
                            .Build())
                    .Build()),
                RootViewController = this,
                Delegate = new StorylyDelegateImpl()
            };
            View.AddSubview(storylyViewCustomization);
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }
    }

    public partial class StorylyDelegateImpl : StorylyDelegate
    {
        public override void StorylyLoaded(StorylyView storylyView, StoryGroup[] storyGroupList, StorylyDataSource dataSource)
        {
            Console.WriteLine($"StorylyLoaded:SGSize:{storyGroupList.Length}");
        }

        public override void StorylyActionClicked(StorylyView storylyView, UIViewController rootViewController, Story story)
        {
            Console.WriteLine($"StorylyActionClicked:ActionUrl:{story.Media.ActionUrl}");
        }

        public override void StorylyEvent(StorylyView storylyView, StorylyEvent @event, StoryGroup storyGroup, Story story, StoryComponent storyComponent)
        {
            Console.WriteLine($"StorylyEvent:StorylyEvent:");
            if (storyComponent != null)
            {
                if (storyComponent.Type == StoryComponentType.Emoji)
                {
                    StoryEmojiComponent emojiComponent = (StoryEmojiComponent)storyComponent;
                    if (emojiComponent != null)
                    {
                        Console.WriteLine($"StorylyEvent:StoryEmojiComponent:{emojiComponent.CustomPayload}");
                    }
                }
            }
        }
    }
}
