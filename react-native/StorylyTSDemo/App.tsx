/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import { NewAppScreen } from '@react-native/new-app-screen';
import React from 'react';
import { Storyly } from 'storyly-react-native';
import { StatusBar, StyleSheet, useColorScheme, View } from 'react-native';

function App() {
  const isDarkMode = useColorScheme() === 'dark';

  return (
    <View style={styles.container}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <Storyly
        style={{ height: "100%" }}
        // ref={ref => { ref?.setExternalData(
        //   [
        //     {
        //       "{Title}": "306",
        //       "{Price}": "1000",
        //       "{Image_url}": "https://img.yad2.co.il/Pic/202202/20/1_1/o/y2_1_03059_20220220170310.jpeg",
        //       "{Button}": "למודעה",
        //       "{Button_url}": "ylbgocfu",
        //       "{sg1_image_url}": "https://img.yad2.co.il/Pic/202202/20/1_1/o/y2_1_03059_20220220170310.jpeg",
        //       "{sg1_price}": "1000",
        //       "{sg1_title}": "306",
        //       "{sg1_subtitle}": "2000",
        //       "{sg1_button}": "ylbgocfu",
        //       "{sg1_button_url}": "ylbgocfu",
        //     }
        //   ]
        // );}}
        storylyId="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MjQ1OTZ9.woksDHkpZURPWfFmCPlTIOVL-c1iwySJO0D6-YkiCd0"
        // onLoad={event => { console.log(event); }}
        // onFail={event => { console.log("[Storyly] onFail"); }}
        // onPress={event => { console.log("[Storyly] onPress"); }}
        // onEvent={event => { console.log("[Storyly] onEvent"); }}
        // onStoryOpen={() => { console.log("[Storyly] onStoryOpen"); }}
        // onStoryClose={() => { console.log("[Storyly] onStoryClose"); }}
        // onUserInteracted={event => { console.log("[Storyly] onUserInteracted"); }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default App;
