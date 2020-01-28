# Storyly
Storyly SDK is used for story representation provided by App Samurai. You can register from [Storyly Dashboard](http://dashboard.storyly.io) and add stories to your registered applications and represent them in application with the help of this package.
## Getting started
Add react-native-appsamurai-ads to your dependencies with one of the options below(yarn or npm);
``` shell
yarn add storyly-react-native
```
``` shell
npm install --save storyly-react-native
```
*Linking library*
react-native 0.60+ handles autolinking as it mentioned in [autolinking in react-native](https://github.com/react-native-community/cli/blob/master/docs/autolinking.md).
For react-native 0.60- version auto linking needs to be done to use libraries with native dependencies correctly. Please refer detailed explanation from [Linking Libraries in iOS](https://facebook.github.io/react-native/docs/linking-libraries-ios.html)
``` shell
react-native link storyly-react-native
```
## Usage
Importing Storyly
```javascript
import Storyly from 'storyly-react-native';
```
Adding as react element
``` js
<Storyly
    style={{ width: '100%', height: 120 }}
    storylyId="[YOUR_APP_ID_FROM_DASHBOARD]"
    onLoad={() => {
        console.log("[Storyly] onStorylyLoaded");
    }}
    onFail={() => {
        console.log("[Storyly] onStorylyLoadFailed");
    }}
    onPress={story => {
        console.log("[Storyly] onStorylyPressed");
    }}
/>
```
## Storyly Events
In Storyly, there are 3 different optional methods that you can override and use.  These are:
* **onLoad**: This function is called when your story groups are loaded without a problem.
* **onFail**: This function is called if any problem occurs while loading story groups such as network problem etc…
* **onPress**: This function is called when the user presses to action button on a story or swipes up in a story. If want to change how the story link should be opened, you need to override this function.
`onPress` function has a parameter called `story`. It's json representation of `Story` object. You can check native documentation for paratemers in detail, also here is the sample format of parameters;
``` json
{
    "index":[int],
    "title":[string],
    "media":{
        "url":[string],
        "type":[int],
        "actionUrl":[string],
        "buttonText":[string],
        "data":{
            [string]:[string],
            [string]:[string],
            [string]:[string],
        }
    }
}
```
## Storyly Methods
* **refresh**: You can call this function to refresh storyly view and load stories again.
## UI Customizations
Using Storyly SDK, you can customize story experience of your users. If you don’t specify any of these attributes, default values will be used. Some of the color related attributes are single color attributes and others require at least two colors.
Here is the list of attributes that you can change:
####  ***Story Group Text Color (Single Color):***
You need to set `storyGroupTextColor: string` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor_1.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor.png)

This attribute changes the text color of the story group.
#### ***Story Group Icon Background Color (Single Color):***
You need to set `storyGroupIconBackgroundColor: string` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground_1.png)

This attribute changes the background color of the story group icon which is shown to the user as skeleton view till the stories are loaded.
#### ***Story Group Icon Border Color Seen (Multiple Colors):***
You need to set `storyGroupIconBorderColorSeen: arrayOf(string)` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen_1.png)

This attribute changes the border color of the story group icon which is already watched by the user. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used.
#### ***Story Group Icon Border Color Not Seen (Multiple Colors):***
You need to set `storyGroupIconBorderColorNotSeen: arrayOf(string)` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen_1.png)

This attribute changes the border color of the story group icon which has not watched by the user yet. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used.
#### ***Pinned Story Group Icon Color (Single Color):***
You need to set `storyGroupPinIconColor: string` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor_1.png)

If any of the story group is selected as pinned story from dashboard, a little icon will appear right bottom side of the story group. This attribute changes the background color of this little icon.
#### ***Story Item Text Color (Single Color):***
You need to set `storyItemTextColor: string` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor_1.png)

This attribute changes the text color of the story item.
#### ***Story Item Icon Border Color (Multiple Color):***
You need to set `storyItemIconBorderColor: arrayOf(string)` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_iconborder.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_iconborder_1.png)

This attribute changes the border color of the story item icon. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used.
#### ***Story Item Progress Bar Color (Two Colors):***
You need to set `storyItemProgressBarColor: arrayOf(string)` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar_1.png)

This attribute changes the colors of the progress bars. The bars consists of two colors.  The first defined color is the color of the background bars and the second one is the color of the foreground bars while watching the stories.
