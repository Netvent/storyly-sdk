import { StyleSheet, Image, Platform } from 'react-native';
import React from "react";

import ParallaxScrollView from '@/components/ParallaxScrollView';
import { IconSymbol } from '@/components/ui/IconSymbol';
import Storyly from 'storyly-react-native-fabric';


const STORYLY_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40'

export default function TabTwoScreen() {
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#D0D0D0', dark: '#353636' }}
      headerImage={
        <IconSymbol
          size={310}
          color="#808080"
          name="chevron.left.forwardslash.chevron.right"
          style={styles.headerImage}
        />
      }>

    <Storyly
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
        onSizeChanged={(event) => {
          console.log(`onSizeChanged: ${JSON.stringify(event)}`)
        }}
        storyGroupSize='large'
        style={{
          width: "100%",
          height: 178,
        }} />   

    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  headerImage: {
    color: '#808080',
    bottom: -90,
    left: -35,
    position: 'absolute',
  },
  titleContainer: {
    flexDirection: 'row',
    gap: 8,
  },
});
