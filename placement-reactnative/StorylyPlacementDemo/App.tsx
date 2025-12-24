/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import { useRef, useState } from 'react';
import { Dimensions, StyleSheet, useColorScheme, View } from 'react-native';
import { StorylyPlacementConfig, StorylyPlacementProviderListener, useStorylyPlacementProvider, StorylyPlacementMethods, StorylyPlacement, STRStoryBarController, STRVideoFeedController, PlacementCartUpdateEvent } from 'storyly-placement-react-native';

function App() {

  return (
    <PlacementScreen name="PlacementScreen" token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU" />
  );
}

export default App;




export const PlacementScreen = ({ name, token }: { name: string, token: string }) => {

  const placementConfig: StorylyPlacementConfig = {
      token: token,
      testMode: true,
      productConfig: {
          isFallbackEnabled: true,
          isCartEnabled: true,
      },
      shareConfig: {
          shareUrl: 'https://www.google.com',
          facebookAppID: '1234567890',
      },
  }

  const placementListener: StorylyPlacementProviderListener = {
      onLoad: (event) => { console.log(`[${name}] onLoad`, event); },
      onLoadFail: (event) => { console.log(`[${name}] onLoadFail`, event); },
      onHydration: (event) => { console.log(`[${name}] onHydration`, event);
      },
  };

  const provider = useStorylyPlacementProvider(placementConfig, placementListener);
  const placementRef = useRef<StorylyPlacementMethods>(null);

  const [placementHeight, setPlacementHeight] = useState<number>(0);

  return (
      <View style={placementStyles.screenContainer}>
          <StorylyPlacement
              style={{ height: placementHeight, width: "100%", backgroundColor: 'lightgray' }}
              ref={placementRef}
              provider={provider}
              onWidgetReady={(event) => {
                  setPlacementHeight(Dimensions.get('window').width / event.ratio);
                  console.log(`[${name}] onWidgetReady`, event, 'calculated height:', placementHeight);
              }}
              onActionClicked={(event) => {
                  if (event.widget.type === 'story-bar' || event.widget.type === 'video-feed') {
                      placementRef.current?.getWidget<STRStoryBarController | STRVideoFeedController>(event.widget).pause();
                  }
                  console.log(`[${name}] onActionClicked`, event);
              }}
              onEvent={(event) => { console.log(`[${name}] onEvent`, event); }}
              onFail={(event) => { console.log(`[${name}] onFail`, event); }}
              onProductEvent={(event) => { console.log(`[${name}] onProductEvent`, event); }}
              onUpdateCart={(event: PlacementCartUpdateEvent) => {
                  console.log(`[${name}] onUpdateCart`, event);
              }}
              onUpdateWishlist={(event) => { console.log(`[${name}] onUpdateWishlist`, event); }}
          />
      </View>
  );
};



const placementStyles = StyleSheet.create({
  screenContainer: {
      flex: 1,
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'flex-start',
  },
})