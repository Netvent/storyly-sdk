import { useRef, useState } from 'react';
import { Button, Dimensions, StyleSheet, View } from 'react-native';
import {
  StorylyPlacement,
  useStorylyPlacementProvider,
  type PlacementCartUpdateEvent,
  type PlacementWidget,
  type StorylyPlacementConfig,
  type StorylyPlacementMethods,
  type StorylyPlacementProviderListener,
} from 'storyly-placement-react-native';

const screenWidth = Dimensions.get('window').width;

interface PlacementScreenProps {
  name: string;
  token: string;
}

export function PlacementScreen({ name, token }: PlacementScreenProps) {
  const placementConfig: StorylyPlacementConfig = {
    token,
    testMode: true,
    productConfig: {
      isFallbackEnabled: true,
      isCartEnabled: true,
    },
    shareConfig: {
      shareUrl: 'https://www.google.com',
      facebookAppId: '1234567890',
    },
  };

  const placementListener: StorylyPlacementProviderListener = {
    onLoad: (event) => { console.log(`[${name}] onLoad`, event); },
    onLoadFail: (event) => { console.log(`[${name}] onLoadFail`, event); },
    onHydration: (event) => { console.log(`[${name}] onHydration`, event); },
  };

  const provider = useStorylyPlacementProvider(placementConfig, placementListener);
  const placementRef = useRef<StorylyPlacementMethods>(null);
  const [placementHeight, setPlacementHeight] = useState<number>(0);
  const [pauseWidget, setPauseWidget] = useState<PlacementWidget | null>(null);

  return (
    <View style={styles.container}>
      <StorylyPlacement
        style={{ height: placementHeight, width: '100%', backgroundColor: 'lightgray' }}
        ref={placementRef}
        provider={provider}
        onWidgetReady={(event) => {
          setPlacementHeight(screenWidth / event.ratio);
          console.log(`[${name}] onWidgetReady`, event);
        }}
        onActionClicked={(event) => {
          placementRef.current?.getWidget(event.widget).pause();
          setPauseWidget(event.widget);
          console.log(`[${name}] onActionClicked`, event);
        }}
        onEvent={(event) => { console.log(`[${name}] onEvent`, event); }}
        onFail={(event) => { console.log(`[${name}] onFail`, event); }}
        onVisibilityChange={(event) => { console.log(`[${name}] onVisibilityChange`, event.isVisible); }}
        onProductEvent={(event) => { console.log(`[${name}] onProductEvent`, event); }}
        onUpdateCart={(event: PlacementCartUpdateEvent) => {
          console.log(`[${name}] onUpdateCart`, event);
          placementRef.current?.approveCartChange(event.responseId);
        }}
        onUpdateWishlist={(event) => {
          console.log(`[${name}] onUpdateWishlist`, event);
          placementRef.current?.approveWishlistChange(event.responseId);
        }}
      />
      {pauseWidget && (
        <Button
          title="Resume Paused Widget"
          onPress={() => {
            placementRef.current?.getWidget(pauseWidget).resume();
            setPauseWidget(null);
          }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'flex-start',
  },
});
