import { useRef, useState } from 'react';
import { PixelRatio, Platform, ScrollView, View } from 'react-native';
import Storyly, { type StorylyMethods } from 'storyly-react-native-fabric';
import { AnimatedWrapper } from './AnimatedView'
import { CustomPortraitView } from './CustomPortraitView';

const STORYLY_TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjE4NjY1fQ._PwkZ48JdHkSU01KUR2n66zJcL29JhykNTMRUorfvE4'



export default function App() {
  const ref = useRef<StorylyMethods | null>(null);

  const [s1Height, setS1Height] = useState(0)
  const [s2Height, setS2Height] = useState(0)

  return (
    <ScrollView>
      <View style={{
          paddingTop: 60,
          flex: 1,
          alignItems: 'center',
          justifyContent: 'center',
      }}>
        <AnimatedWrapper animHeight={178}>
          <Storyly
            ref={ref}
            style={{
              width: "100%",
              height: 178,
            }}
            storylyId={STORYLY_TOKEN}
            storyGroupViewFactory={{
              width: convertToNative(90),
              height: convertToNative(178),
              customView: CustomPortraitView
            }}
            storyGroupListHorizontalEdgePadding={convertToNative(24)}
            onLoad={(event) => {
              let log = event.storyGroupList.map(group => (
                `${event.dataSource} - GroupId:${group.id} - StoryIds[${group.stories.map(story => (story.id)).join(", ")}]`
              )).join(", ")
              console.log(`onLoad: ${log}`)
            }}
            onFail={(event) => {
              console.log(`onFail: ${JSON.stringify(event)}`)
            }}
            onStoryOpen={() => {
              console.log(`onStoryOpen`)
            }}
            onStoryClose={() => {
              console.log(`onStoryClose`)
            }}
            onStoryOpenFailed={(event) => {
              console.log(`onStoryOpenFailed: ${JSON.stringify(event)}`)
            }}
            onEvent={(event) => {
              console.log(`onEvent: ${JSON.stringify(event)}`)
            }}
            onPress={(event) => {
              console.log(`onPress: ${JSON.stringify(event)}`)
            }}
            onUserInteracted={(event) => {
              console.log(`onUserInteracted: ${JSON.stringify(event)}`)
            }}
            onProductHydration={(event) => {
              console.log(`onProductHydration: ${JSON.stringify(event)}`)
            }}
            onCartUpdate={(event) => {
              console.log(`onCartUpdate: ${JSON.stringify(event)}`)
            }}
            onProductEvent={(event) => {
              console.log(`onProductEvent: ${JSON.stringify(event)}`)
            }}
            onSizeChanged={(event) => {
              console.log(`onSizeChanged: ${JSON.stringify(event)}`)
            }}
           />
        </AnimatedWrapper>

        <Storyly
          storylyId={STORYLY_TOKEN}
          storyGroupSize='small'
          style={{
            width: "100%",
            height: s1Height,
          }}
          onSizeChanged={(size) => { setS1Height(convertFromNative(size.height)) }} />

        <Storyly
          style={{ width: '100%', height: s2Height, marginTop: 10, backgroundColor: "#e9967a" }}
          storylyId={STORYLY_TOKEN}
          storyGroupSize="custom"
          storyGroupIconHeight={convertToNative(150)}
          storyGroupIconWidth={convertToNative(100)}
          storyGroupIconCornerRadius={convertToNative(20)}
          storyGroupListHorizontalEdgePadding={convertToNative(20)}
          storyGroupListHorizontalPaddingBetweenItems={convertToNative(10)}
          storyGroupTextSize={convertToNative(20)}
          storyGroupTextLines={3}
          storyGroupTextColorSeen={"#00FF00"}
          storyGroupTextColorNotSeen={"#FF0000"}
          storyGroupIconBorderColorNotSeen={["#FF0000", "#FF0000"]}
          storyGroupIconBorderColorSeen={["#FFFFFF", "#FFFFFF"]}
          storyGroupIconBackgroundColor={"#000000"}
          storyGroupPinIconColor={"#000000"}
          onSizeChanged={(size) => { setS2Height(convertFromNative(size.height)) }} />
      </View>
    </ScrollView>
  );
}


const convertToNative = (size: number) => {
  return Platform.OS === 'android' ? PixelRatio.getPixelSizeForLayoutSize(size) : size
}

const convertFromNative = (size: number) => {
  return Platform.OS === 'android' ? size / PixelRatio.get() : size
}
