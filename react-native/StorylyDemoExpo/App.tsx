import { StatusBar } from 'expo-status-bar';
import { StyleSheet, View } from 'react-native';
import { Storyly } from 'storyly-react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Storyly
        style={{ width: '100%', height: 120 }}
        storylyId="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"
      />      

      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
