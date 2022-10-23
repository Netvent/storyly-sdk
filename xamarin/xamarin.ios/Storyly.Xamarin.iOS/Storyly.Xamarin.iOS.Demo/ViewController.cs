using CoreGraphics;
using System;
using UIKit;
using Storyly;

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

            var storylyView = new StorylyView(new CGRect(0, 40, 414, 130));
            storylyView.StorylyInit = new StorylyInit("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40");
            storylyView.RootViewController = this;
            storylyView.Delegate = new StorylyDelegateImpl();
            View.AddSubview(storylyView);
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
    }
}
