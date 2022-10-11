/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React, { useRef } from 'react';
import {
  Button,
  View,
  SafeAreaView,
  StyleSheet,
} from 'react-native';

import { setStorylyAdViewProvider } from 'storyly-monetization-react-native';

import { Storyly } from 'storyly-react-native';

export default function App() {
  const storyly = useRef<Storyly>(null)

  return (
    <SafeAreaView style={styles.container}>
       <Storyly
          ref={storyly}
          style={{ width: '100%', height: 120, marginTop: 44 }}
          storylyId="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjE0Mjd9.cGTn_uElzFerKU-ul3EnrTn7pMZlhA3HvG4EEoygDcQ"
          onLoad={storyGroupList => {
              console.log("[Storyly] onLoad");
              setStorylyAdViewProvider(storyly.current, {adMobAdUnitId: "ca-app-pub-3940256099942544/2247696110", adMobAdExtras: {"npa": "1", "aa": {"test": "a"}}}) 
          }}
          onFail={errorMessage => {
              console.log("[Storyly] onFail");
          }}
          onPress={story => {
              console.log("[Storyly] onPress");
          }}
          onEvent={eventPayload => {
              console.log("[Storyly] onEvent");
          }}
          onStoryOpen={() => {
              console.log("[Storyly] onStoryOpen");
          }}
          onStoryClose={() => {
              console.log("[Storyly] onStoryClose");
          }}
          onUserInteracted={interactionEvent => {
              console.log("[Storyly] onStoryUserInteracted");
          }}/>
      <View style={styles.box}>
        <Button 
          onPress={() => {
            if (storyly) { setStorylyAdViewProvider(storyly.current, {adMobAdUnitId: "ca-app-pub-3940256099942544/2247696110", adMobAdExtras: {"npa": "1", "aa": {"test": "a"}}})  } 
          }}
          title="Add Ad Provider To Storyly"
          color="#7A4BFF"
        />
      </View> 
      <View style={styles.box}>
        <Button 
          onPress={() => {
            if (storyly) { setStorylyAdViewProvider(storyly.current,  {adMobAdUnitId: "ca-app-pub-3940256099942544/2521693316"}) }
          }}
          title="Add Video Ad Provider To Storyly"
          color="#7A4BFF"
        />
      </View> 
      <View style={styles.box}>
        <Button 
          onPress={() => {
            if (storyly) { setStorylyAdViewProvider(storyly.current,  null) }
          }}
          title="Remove Ad Provider From Storyly"
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


