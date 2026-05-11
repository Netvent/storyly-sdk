import { useState } from 'react';
import { View, TouchableOpacity, Text, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { PlacementScreen } from '@/components/placement-screen';

const TABS = [
  {
    label: 'Story Bar',
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU',
  },
  {
    label: 'Video Feed',
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6MjQwNDIsInQiOjF9.Uj9rEBowMUOP4zqueJQ8stXJXHdFOKoac8sKUEM8K5M',
  },
  {
    label: 'Banner',
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDcwLCJzZGtfcGwiOiJpb3MifQ.jAIGPCEy1GES5WQMzjqlWKj_LuPLkkLAtsTdWmwF0MM',
  },
  {
    label: 'Swipe Card',
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDcxLCJzZGtfcGwiOiJpb3MifQ.MeIfgCW71K0LweUH2_b16ODoPFp0MX5dQUer08SrI5k',
  },
] as const;

export default function HomeScreen() {
  const [activeIndex, setActiveIndex] = useState(0);
  const activeTab = TABS[activeIndex];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.tabBar}>
        {TABS.map((tab, index) => (
          <TouchableOpacity
            key={index}
            style={[styles.tabItem, activeIndex === index && styles.activeTabItem]}
            onPress={() => setActiveIndex(index)}
          >
            <Text style={[styles.tabText, activeIndex === index && styles.activeTabText]}>
              {tab.label}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
      <View style={styles.content}>
        <PlacementScreen key={activeIndex} name={activeTab.label} token={activeTab.token} />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  tabBar: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
    backgroundColor: '#fff',
  },
  tabItem: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
  },
  activeTabItem: {
    borderBottomWidth: 2,
    borderBottomColor: '#007aff',
  },
  tabText: {
    fontSize: 11,
    color: '#666',
  },
  activeTabText: {
    color: '#007aff',
    fontWeight: '600',
  },
  content: {
    flex: 1,
  },
});
