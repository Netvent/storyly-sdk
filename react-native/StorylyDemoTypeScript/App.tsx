/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import {
  SafeAreaView,
  StatusBar,
  useColorScheme,
} from 'react-native';

import {
  Colors,
} from 'react-native/Libraries/NewAppScreen';

import { Storyly } from 'storyly-react-native';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <Storyly
        style={{ height: "100%" }}
        storylyId="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"
        onLoad={event => { console.log("[Storyly] onLoad"); }}
        onFail={event => { console.log("[Storyly] onFail"); }}
        onPress={event => { console.log("[Storyly] onPress"); }}
        onEvent={event => { console.log("[Storyly] onEvent"); }}
        onStoryOpen={() => { console.log("[Storyly] onStoryOpen"); }}
        onStoryClose={() => { console.log("[Storyly] onStoryClose"); }}
        onUserInteracted={event => { console.log("[Storyly] onUserInteracted"); }}
      />
    </SafeAreaView>
  );
};

export default App;
