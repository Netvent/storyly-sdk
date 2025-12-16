import { useRef, useState } from 'react';
import { View, StyleSheet, Dimensions, Button } from 'react-native';
import { useStorylyPlacementProvider, StorylyPlacement, type StorylyPlacementConfig, type StorylyPlacementMethods } from 'storyly-placement-react-native';
import type { PlacementWidget, StorylyPlacementProviderListener, STRBannerPayload, STRStoryBarController } from 'storyly-placement-react-native';


const screenWidth = Dimensions.get('window').width;

export default function App() {
  const placementConfig: StorylyPlacementConfig = {
    token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTcxODUsImluc19pZCI6MTkxMDB9.AmtkzTlj_g3RQwwHZTz6rsozH8VFqAogeSwgBdXLMDU",
  };

  const placementListener: StorylyPlacementProviderListener = {
    onLoad: (event) => { console.log('onLoad', event); },
    onLoadFail: (event) => { console.log('onLoadFail', event); },
    onHydration: (event) => {
      console.log('onHydration', event);
      // provider.hydrateProducts([]);
    },
  };
  const provider = useStorylyPlacementProvider(placementConfig, placementListener);

  const placementRef = useRef<StorylyPlacementMethods>(null);
  const [placementHeight, setPlacementHeight] = useState<number>(0);

  const [pauseWidget, setPauseWidget] = useState<PlacementWidget | null>(null);

  return (
    <View style={styles.container}>
      <StorylyPlacement
        style={{height: placementHeight, width: "100%", backgroundColor: 'gray'}}
        ref={placementRef}
        provider={provider}
        onWidgetReady={(event) => {
          setPlacementHeight(screenWidth / event.ratio);
          console.log('onWidgetReady', event, 'calculated height:', placementHeight);
        }}
        onActionClicked={(event) => {
          if (event.widget.type === 'story-bar') {
            placementRef.current?.getWidget<STRStoryBarController>(event.widget).pause();
            setPauseWidget(event.widget);
          }
          console.log('onActionClicked', event);
        }}
        onEvent={(event) => {
          if (event.widget.type === 'story-bar') {
            // placementRef.current?.getWidget<STRStoryBarController>(event.widget).pause();
          }
          console.log('onEvent', event);
        }}
        onFail={(event) => {
          console.log('onFail', event);
        }}
        onProductEvent={(event) => {
          console.log('onProductEvent', event);
        }}
        onUpdateCart={(event) => {
          console.log('onUpdateCart', event);
        }}
        onUpdateWishlist={(event) => {
          console.log('onUpdateWishlist', event);
        }}
        />

<Button title="Resume Paused Story Bar"   onPress={() => {
        if (pauseWidget) {
          placementRef.current?.getWidget<STRStoryBarController>(pauseWidget).resume();
          setPauseWidget(null);
        }
      }} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'white',
    // flex: 1,
    flexDirection: 'column',
    alignItems: 'flex-start',
    justifyContent: 'center',
  },
});
