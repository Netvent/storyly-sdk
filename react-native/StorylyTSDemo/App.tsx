/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, { useRef } from 'react';
import { Storyly } from 'storyly-react-native';
import { StatusBar, StyleSheet, View, Text, Image, Dimensions, PixelRatio, SafeAreaView } from 'react-native';

function App() {

  const storylyRef = useRef<Storyly>(null);

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle={'light-content'} />
      <Storyly
        style={{ height: "100%", width: "100%" }}
        ref={storylyRef}
        storylyId="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU"
        onLoad={event => {
          console.log(event)
        }}
        storyGroupListOrientation='vertical'
        storyGroupViewFactory={{
          width: styles.customCard.width,
          height: styles.customCard.height,
          customView: viewFactory,
        }}
      />
    </SafeAreaView>
  );
}

const CARD_HEIGHT = PixelRatio.getPixelSizeForLayoutSize(45);
const ICON_SIZE = PixelRatio.getPixelSizeForLayoutSize(35);

const viewFactory = ({ storyGroup }: { storyGroup: Storyly.StoryGroup }) => {
  if (!storyGroup) return <View style={styles.customCard} />;
  console.log(storyGroup)
  return (
    <View style={styles.customCard}>
      <View style={styles.iconContainer}>
        {storyGroup.iconUrl ? (
          <Image
            source={{ uri: storyGroup.iconUrl }}
            style={styles.icon}
            resizeMode="cover"
          />
        ) : (
          <View style={styles.iconContainer} />
        )}
      </View>

      <View style={styles.contentContainer}>
        <Text style={styles.title} numberOfLines={2}>
          {storyGroup.title}
        </Text>
        {storyGroup.stories && storyGroup.stories.length > 0 && (
          <Text style={styles.description} numberOfLines={2}>
            {storyGroup.stories[0].title}
          </Text>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#F1F1F1'
  },
  customCard: {
    flexDirection: 'row',
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 12,
    marginVertical: 6,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.08,
    shadowRadius: 4,
    elevation: 3,
    width: Dimensions.get('window').width,
    height: CARD_HEIGHT,
  },
  iconContainer: {
    marginRight: 12,
    justifyContent: 'center',
  },
  icon: {
    width: ICON_SIZE,
    height: ICON_SIZE,
    borderRadius: 8,
  },
  contentContainer: {
    flex: 1,
    justifyContent: 'center',
  },
  title: {
    fontSize: 17,
    fontWeight: '700',
    color: '#1A1A1A',
    marginBottom: 4,
  },
  description: {
    fontSize: 14,
    color: '#666666',
    marginBottom: 4,
  },
});

export default App;
