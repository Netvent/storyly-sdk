import { useState } from 'react';
import { View, StyleSheet, TouchableOpacity, Text, Platform } from 'react-native';
import { PlacementScreen } from './PlacementScreen';


const TABS = [
  { label: 'Story Bar', token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU" },
  { label: 'Video Feed', token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6MjQwNDIsInQiOjF9.Uj9rEBowMUOP4zqueJQ8stXJXHdFOKoac8sKUEM8K5M"   },
  { label: 'Banner', token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDcwLCJzZGtfcGwiOiJpb3MifQ.jAIGPCEy1GES5WQMzjqlWKj_LuPLkkLAtsTdWmwF0MM" },
  { label: 'Swipe Card', token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDcxLCJzZGtfcGwiOiJpb3MifQ.MeIfgCW71K0LweUH2_b16ODoPFp0MX5dQUer08SrI5k" },
] as Array<{ label: string, token: string }> ;



export default function App() {
  const [activeTabIndex, setActiveTabIndex] = useState(0);

  return (
    <View style={styles.container}>
      <View style={styles.content}>
        {TABS.map( (tab, index) => (
            <View key={index} style={[styles.tabContent, { display: index ===  activeTabIndex? 'flex' : 'none' }]}>
                <PlacementScreen name={tab.label} token={tab.token} />
            </View>
        ))}
      </View>
      <View style={styles.tabBar}>
        {TABS.map((tab, index) => (
          <TouchableOpacity
            key={index}
            style={[styles.tabItem, activeTabIndex === index && styles.activeTabItem]}
            onPress={() => setActiveTabIndex(index)}
          >
            <Text style={[styles.tabText, activeTabIndex === index && styles.activeTabText]}>{tab.label}</Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
    marginTop: 60,
  },
  content: {
    flex: 1,
  },
  tabContent: {
      flex: 1,
      width: '100%',
  },
  tabBar: {
    flexDirection: 'row',
    height: 60,
    borderTopWidth: 1,
    borderTopColor: '#eee',
    backgroundColor: '#fff',
    marginBottom: 20, 
  },
  tabItem: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 10,
  },
  activeTabItem: {
    backgroundColor: '#f8f9fa',
  },
  tabText: {
    fontSize: 12,
    color: '#666',
    marginTop: 4,
  },
  activeTabText: {
    color: '#007aff',
    fontWeight: '600',
  },
});
