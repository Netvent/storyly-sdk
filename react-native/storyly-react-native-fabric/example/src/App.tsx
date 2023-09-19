import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { Storyly } from 'storyly-react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Storyly 
        storylyId='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40'
        onLoad={(event) => {
            console.log(event.dataSource)
        }} />
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
