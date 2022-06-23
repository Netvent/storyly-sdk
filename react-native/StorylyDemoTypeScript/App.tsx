/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

// In index.js of a new project
import React from 'react';
import { View, Text, Button, StyleSheet } from 'react-native';
import { Navigation } from 'react-native-navigation';
import { Storyly } from 'storyly-react-native';

// Home screen declaration
const HomeScreen = (props) => {
  console.log("Storyly:HomeScreen:render");
  return (
    <View style={{flex: 1}}>
      <Button
        title='Push Settings Screen'
        color='#710ce3'
        onPress={() => Navigation.push(props.componentId, {
          component: {
            name: 'Settings',
            options: {
              topBar: {
                title: {
                  text: 'Settings'
                }
              }
            }
          }
        })}/>
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
    </View>
  );
};
HomeScreen.options = {
  topBar: {
    title: {
      text: 'Home',
      color: 'white'
    },
    background: {
      color: '#4d089a'
    }
  }
};

// Settings screen declaration - this is the screen we'll be pushing into the stack
const SettingsScreen = () => {
  console.log("Storyly:SettingsScreen:render");
  return (
    <View style={styles.root}>
      <Text>Settings Screen</Text>
    </View>
  );
}

Navigation.registerComponent('Home', () => HomeScreen);
Navigation.registerComponent('Settings', () => SettingsScreen);

Navigation.events().registerAppLaunchedListener(async () => {
  Navigation.setRoot({
    root: {
      stack: {
        children: [
          {
            component: {
              name: 'Home'
            }
          }
        ]
      }
    }
  });
});

const styles = StyleSheet.create({
  root: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'whitesmoke'
  }
});