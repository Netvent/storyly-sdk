import * as React from 'react';
import { useRef } from 'react';

import { Image, StyleSheet, Text, View } from 'react-native';
import type { StoryGroup } from 'src/data/story';
import Storyly, { type StorylyProps } from 'storyly-react-native';

const CustomPortraitView: React.FC<{storyGroup?: StoryGroup}> = ({ storyGroup }) => {
  return (
      <>
          {(storyGroup ? (
              <View style={{ width: "100%", height: "100%", backgroundColor: "yellow"}}>
                   <Image
                    style={{
                      width: "100%",
                      height: "100%",
                      borderRadius: 8
                    }}
                    source={{ uri: storyGroup.iconUrl }} />
                  <View style={{ width: 100, height: 178, borderRadius: 8, position: 'absolute', backgroundColor: storyGroup.seen ? "#16ad055f" : "#1905ad5f" }}>
                      <View style={{ flexDirection: 'column', width: 90, marginTop: 20, marginLeft: 5, height: "100%", alignItems: 'center', justifyContent: 'flex-start' }}>
                          <Text style={{ flexWrap: 'wrap', width: "90%", textAlign: 'center', fontWeight: 'bold', fontSize: 15, color: "white" }}>{storyGroup.title}</Text>
                      </View>
                  </View> 
              </View>
          ) : (
              <View style={{ width: "100%", height: "100%", borderRadius: 8, backgroundColor: "grey" }}></View>
          ))}
      </>
  )
}


export default function App() {
  const ref = useRef<StorylyProps>(null)

  return (
    <View style={styles.container}>
      <Storyly
        ref={(storylyRef) => {
          if (storylyRef) {
            storylyRef.openStoryWithId("26763", "191223");
          }
        }}
        storylyId='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjE0Mjd9.cGTn_uElzFerKU-ul3EnrTn7pMZlhA3HvG4EEoygDcQ'
        storyGroupSize='custom'
        storyGroupViewFactory={{
          customView: CustomPortraitView,
          width: 100,
          height: 178,
        }}
        style={{
          width: "100%",
          height: 178,
        }}
        />
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
