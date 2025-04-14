import { useRef, useState } from 'react';
import { Image, PixelRatio, Platform, ScrollView, StyleSheet, Text, View } from 'react-native';
import Storyly, { type StorylyMethods, type StoryGroup } from 'storyly-react-native-fabric';

const STORYLY_TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjE4NjY1fQ._PwkZ48JdHkSU01KUR2n66zJcL29JhykNTMRUorfvE4'


export default function App() {
  const ref = useRef<StorylyMethods | null>(null);

  const [s1Height, setS1Height] = useState(0)
  const [s2Height, setS2Height] = useState(0)

  return (
    <ScrollView>
      <View style={styles.container}>
          <Storyly
            ref={ref}
            storylyId={STORYLY_TOKEN}
            storyGroupViewFactory={{
              width: convertToNative(90),
              height: convertToNative(178),
              customView: CustomPortraitView
            }}
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
            onSizeChanged={(event) => {
              console.log(`onSizeChanged: ${JSON.stringify(event)}`)
            }}
            style={{
              width: "100%",
              height: 178,
            }} />

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


const CustomPortraitView: React.FC<{ storyGroup?: StoryGroup }> = ({ storyGroup }) => {
  console.log(`STR:RN: CustomPortraitView: ${storyGroup?.index} - ${storyGroup?.id}`)
  if (!storyGroup) {
    return <View style={customStyle.placeholderCard} />;
  }

  const overlayColor = storyGroup.seen ? 'rgba(22, 173, 5, 0.5)' : 'rgba(25, 5, 173, 0.5)';

  return (
    <View style={customStyle.cardContainer}>
      <Image source={{ uri: storyGroup.stories?.at(0)?.previewUrl }} style={customStyle.backgroundImage} />
      <View style={[customStyle.overlay, { backgroundColor: overlayColor }]}>
        <View style={customStyle.textWrapper}>
          <Text style={customStyle.titleText} numberOfLines={0}>
            {storyGroup.index} - {storyGroup.id}
          </Text>
          <Image style={customStyle.imageIcon} source={{uri: storyGroup.iconUrl}} />
        </View>
      </View>
    </View>
  );
};


const customStyle = StyleSheet.create({
  cardContainer: {
    width: 90,
    height: 178,
    borderRadius: 8,
    overflow: 'hidden',
    position: 'relative',
  },
  backgroundImage: {
    width: '100%',
    height: '100%',
    resizeMode: 'cover',
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 6,
  },
  textWrapper: {
    width: '100%',
    paddingHorizontal: 6,
  },
  titleText: {
    color: 'white',
    fontSize: 14,
    fontWeight: 'bold',
    textAlign: 'center',
    includeFontPadding: false,
    textAlignVertical: 'center',
    lineHeight: 16,
  },
  imageIcon: {
    width: 50,
    height: 50,
    borderRadius: 25,
    alignSelf: 'center'
  },
  placeholderCard: {
    width: 90,
    height: 178,
    borderRadius: 8,
    backgroundColor: '#00FF00',
  },
});



const convertToNative = (size: number) => {
  return Platform.OS === 'android' ? PixelRatio.getPixelSizeForLayoutSize(size) : size
}

const convertFromNative = (size: number) => {
  return Platform.OS === 'android' ?  size / PixelRatio.get() : size
}

const styles = StyleSheet.create({
  container: {
    paddingTop: 60,
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
