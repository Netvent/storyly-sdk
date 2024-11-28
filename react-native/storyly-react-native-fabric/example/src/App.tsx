import { useRef } from 'react';
import { PixelRatio, Platform, StyleSheet, View } from 'react-native';
import Storyly, { type StorylyMethods } from 'storyly-react-native-fabric';

const STORYLY_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40'

const convertToNative = (size: number) => {
  return Platform.OS === 'android' ? PixelRatio.getPixelSizeForLayoutSize(size) : size
}

export default function App() {
  const ref = useRef<StorylyMethods | null>(null);

  return (
    <View style={styles.container}>
      <Storyly
        ref={ref}
        storylyId={STORYLY_TOKEN}
        onLoad={(event) => {
          let log = event.storyGroupList.map(group => (
            `${event.dataSource} - GroupId:${group.id} - StoryIds[${group.stories.map(story => ( story.id )).join(", ")}]`
          )).join(", ")
          console.log(`onLoad: ${log}`)
          // ref.current
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
        // onSizeChanged{(event) => {}}
        storyGroupSize='large'
        style={{
          width: "100%",
          height: 178,
        }} />

      <Storyly
        storylyId={STORYLY_TOKEN}
        storyGroupSize='small'
        style={{
          width: "100%",
          height: 178,
        }} />

      <Storyly
        style={{ width: '100%', height: 170, marginTop: 10, backgroundColor: "#e9967a" }}
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
        storyGroupPinIconColor={"#000000"} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
