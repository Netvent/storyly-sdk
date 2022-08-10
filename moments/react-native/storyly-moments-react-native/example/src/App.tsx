import * as React from 'react';

import { StyleSheet, View, Button, SafeAreaView } from 'react-native';
import StorylyMoments from 'storyly-moments-react-native';

export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.box}>
        <Button 
          onPress={() => 
            StorylyMoments.initialize(
              [MOMENTS_TOKEN], 
              [MOMENTS_USER_PAYLOAD]
            )
          }
          title="Initialize Moments"
          color="#242450"
        />
      </View>
      <View style={styles.box}>
        <Button 
          onPress={() => StorylyMoments.openUserStories() }
          title="Show User Stories"
          color="#00E0E4"
        />
      </View>
      <View style={styles.box}>
        <Button 
          onPress={() => StorylyMoments.openStoryCreator() }
          title="Create Story"
          color="#7A4BFF"
        />
      </View>
      <View style={styles.box}>
        <Button
         title="Initialize events"
         color="#00E0E4"
          onPress={() => {
            StorylyMoments.addEventListener("storylyMomentsEvent", (event: Object) => {
              console.log(`app - storylyMomentsEvent - ${event.eventName} - ${JSON.stringify(event.storyGroup)} - ${JSON.stringify(event.stories)}`)
            })
            StorylyMoments.addEventListener("onOpenCreateStory", (event: Object) => {
              console.log(`onOpenCreateStory - ${JSON.stringify(event)}`)
            })
            StorylyMoments.addEventListener("onOpenMyStory", (event: Object) => {
              console.log(`onOpenMyStory - ${JSON.stringify(event)}`)
            })
            StorylyMoments.addEventListener("onUserStoriesLoaded", (event: Object) => {
              console.log(`onUserStoriesLoaded - ${JSON.stringify(event)}`)
            })
            StorylyMoments.addEventListener("onUserStoriesLoadFailed", (event: Object) => {
              console.log(`onUserStoriesLoadFailed - ${JSON.stringify(event)}`)
            })
          }}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 180,
    height: 60,
  },
});
