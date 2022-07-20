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
