# Storyly SDK Demo with Expo

A demo app to show how to use `storyly-react-native` package with Expo.

## Expo Go vs Expo Development Builds

Since `storyly-react-native` is a native module, you can't directly use it with [Expo Go](https://docs.expo.dev/get-started/expo-go/). To use native modules with Expo, you can either use [`expo prebuild`](https://docs.expo.dev/workflow/prebuild/) or you can generate an [Expo Development Build](https://docs.expo.dev/develop/development-builds/introduction/).

You can think of a development build as your version of the Expo Go client. It generates a custom Expo Go app with your installed native packages. This workflow allows you to use any native packages on your app while keeping Expo Go's ease of development.