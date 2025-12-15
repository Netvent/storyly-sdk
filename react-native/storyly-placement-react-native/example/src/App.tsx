import { useRef, useState } from 'react';
import { View, StyleSheet, Dimensions } from 'react-native';
import { useStorylyPlacementProvider, StorylyPlacement, type StorylyPlacementConfig, type StorylyPlacementMethods } from 'storyly-placement-react-native';
import type { StorylyPlacementProviderListener, STRBannerPayload } from 'storyly-placement-react-native';


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
          if (event.widget === 'banner') {
            const bannerPayload = event.payload as STRBannerPayload;
            console.log('bannerEvent', bannerPayload.item?.uniqueId, bannerPayload.component?.type);
          }
          console.log('onActionClicked', event);
        }}
        onEvent={(event) => {
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
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
