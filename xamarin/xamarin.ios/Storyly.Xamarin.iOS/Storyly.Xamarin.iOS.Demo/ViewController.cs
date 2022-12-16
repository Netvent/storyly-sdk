using System;
using CoreGraphics;
using Foundation;
using UIKit;

namespace Storyly.Xamarin.iOS.Demo
{
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
                StorylyInit = new StorylyInit("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"),
                RootViewController = this,
                Delegate = new StorylyDelegateImpl(),
                StoryGroupSize = "small"
            };
            View.AddSubview(storylyView);

            var womenStorylyView = new StorylyView(new CGRect(0, 150, 414, 130))
            {
                StorylyInit = new StorylyInit("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjgyNDgsImFwcF9pZCI6MTM0MzEsImluc19pZCI6MTQ2MTh9.Q6RtSOt-yIcT2op9tS_hborpKLhOpPfV6wn_9tiFNkQ",
                new StorylySegmentation(new NSSet<NSString>(new NSString("women"))),
                null,
                false,
                null,
                new NSDictionary<NSString, NSString>(
                    new NSString("username"), new NSString("Nurcin")
                )),
                RootViewController = this,
                Delegate = new StorylyDelegateImpl()
            };
            womenStorylyView.SetExternalData(new[] {
                new NSDictionary(
                    new NSString("{Media_1}"), new NSString("https://xcdn.next.co.uk/common/items/default/default/publications/g65/shotzoom/149/t60-284s.jpg"),
                    new NSString("{Product Name}"), new NSString("Shower Resistant Faux Fur Hooded Parka"),
                    new NSString("{Price}"), new NSString("£92"),
                    new NSString("{Description}"), new NSString("Update your wardrobe for winter with this fashionable and functional coat."),
                    new NSString("{CTA}"), new NSString("Buy Now"),
                    new NSString("{CTA_URL}"), new NSString("https://www3.next.co.uk/g65149s2/t60284#t60284")
                    )
            });
            View.AddSubview(womenStorylyView);

            var menStorylyView = new StorylyView(new CGRect(0, 290, 414, 130))
            {
                StorylyInit = new StorylyInit("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjgyNDgsImFwcF9pZCI6MTM0MzEsImluc19pZCI6MTQ2MTh9.Q6RtSOt-yIcT2op9tS_hborpKLhOpPfV6wn_9tiFNkQ",
                new StorylySegmentation(new NSSet<NSString>(new NSString("men"))),
                null,
                false,
                null,
                new NSDictionary<NSString, NSString>(
                    new NSString("username"), new NSString("Levent")
                )),
                RootViewController = this,
                Delegate = new StorylyDelegateImpl()
            };
            View.AddSubview(menStorylyView);
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
