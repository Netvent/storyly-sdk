import { StyleSheet, View } from 'react-native';
import { WebView } from 'react-native-webview';

export default function App() {
  return (
    <View style={{ flex:1 }}>
      <WebView
        style={{ ...styles.container }}
        source={{
          html: `
          <script custom-element="storyly-web" src="https://web-story.storyly.io/v2/storyly-web.js"></script>
          <storyly-web></storyly-web>
          <script>
              const storylyWeb = document.querySelector('storyly-web');
              storylyWeb.init({
                token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIxOSwiYXBwX2lkIjoxNjM5NCwiaW5zX2lkIjoxODA0OX0.1FdJH8los0-qHEI7KsjRDa-WVrKffv18bIP29XJi5Yk',
              });
          </script>
          ` }}
      />
      </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginTop: 100,
    width: '100%',
    maxHeight: 100
  },
});
