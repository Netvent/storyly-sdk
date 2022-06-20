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
   Button,
   View,
 } from 'react-native';
 
 import { Storyly } from 'storyly-react-native';
 import { NavigationContainer } from '@react-navigation/native';
 import { createNativeStackNavigator } from '@react-navigation/native-stack';
 
 function HomeScreen({ navigation }) {
   console.log("HomeScreen:Create");
   return (
     <View style={{ flex: 1 }}>
       <Button
         title="Go to Profile"
         onPress={() => navigation.navigate('Profile')} 
       />
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
 }
 
 function ProfileScreen({ navigation }) {
   return (
     <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
       <Button
         title="Go to Notifications"
         onPress={() => navigation.navigate('Notifications')}
       />
       <Button title="Go back" onPress={() => navigation.goBack()} />
     </View>
   );
 }
 
 function NotificationsScreen({ navigation }) {
   return (
     <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
       <Button
         title="Go to Settings"
         onPress={() => navigation.navigate('Settings')}
       />
       <Button title="Go back" onPress={() => navigation.goBack()} />
     </View>
   );
 }
 
 function SettingsScreen({ navigation }) {
   return (
     <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
       <Button title="Go back" onPress={() => navigation.goBack()} />
     </View>
   );
 }
 
 const Stack = createNativeStackNavigator();
 
 function MyStack() {
   return (
     <Stack.Navigator>
       <Stack.Screen name="Home" component={HomeScreen}/>
       <Stack.Screen name="Notifications" component={NotificationsScreen} />
       <Stack.Screen name="Profile" component={ProfileScreen} />
       <Stack.Screen name="Settings" component={SettingsScreen} />
     </Stack.Navigator>
   );
 }
 
 const App = () => {
   return (
     <NavigationContainer>
       <MyStack />
     </NavigationContainer>
   );
 }
 
 export default App;