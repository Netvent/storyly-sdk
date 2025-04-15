import { View, Image, Text, StyleSheet } from "react-native";
import type { StoryGroup } from "storyly-react-native-fabric";


export const CustomPortraitView: React.FC<{ storyGroup?: StoryGroup }> = ({ storyGroup }) => {
    console.log(`STR:RN: CustomPortraitView: ${storyGroup?.index} - ${storyGroup?.id}`)
    if (!storyGroup) {
      return <View style={customStyle.placeholderCard} />;
    }
  
    const overlayColor = storyGroup.seen ? 'rgba(22, 173, 5, 0.5)' : 'rgba(25, 5, 173, 0.5)';
  
    return (
      <View style={customStyle.cardContainer}>
        <Image source={{ uri: storyGroup.stories?.at(0)?.previewUrl }} style={customStyle.backgroundImage} />
        <View style={[customStyle.overlay, { backgroundColor: overlayColor }]}>
          <View style={customStyle.textWrapper}>
            <Text style={customStyle.titleText} numberOfLines={0}>
              {storyGroup.index} - {storyGroup.id}
            </Text>
            <Image style={customStyle.imageIcon} source={{ uri: storyGroup.iconUrl }} />
          </View>
        </View>
      </View>
    );
  };
  
  
  const customStyle = StyleSheet.create({
    cardContainer: {
      width: 90,
      height: 178,
      borderRadius: 8,
      overflow: 'hidden',
      position: 'relative',
    },
    backgroundImage: {
      width: '100%',
      height: '100%',
      resizeMode: 'cover',
    },
    overlay: {
      ...StyleSheet.absoluteFillObject,
      justifyContent: 'center',
      alignItems: 'center',
      paddingHorizontal: 6,
    },
    textWrapper: {
      width: '100%',
      paddingHorizontal: 6,
    },
    titleText: {
      color: 'white',
      fontSize: 14,
      fontWeight: 'bold',
      textAlign: 'center',
      includeFontPadding: false,
      textAlignVertical: 'center',
      lineHeight: 16,
    },
    imageIcon: {
      width: 50,
      height: 50,
      borderRadius: 25,
      alignSelf: 'center'
    },
    placeholderCard: {
      width: 90,
      height: 178,
      borderRadius: 8,
      backgroundColor: '#00FF00',
    },
  });