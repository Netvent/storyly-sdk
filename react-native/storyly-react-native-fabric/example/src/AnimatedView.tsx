import { type ReactNode, useRef, useState } from "react";
import { Animated, View, TouchableOpacity, Text } from "react-native";


export const AnimatedWrapper = ({ children, animHeight }: { children: ReactNode; animHeight: number }) => {
  const animatedHeight = useRef(new Animated.Value(0)).current;
  const [isVisible, setIsVisible] = useState(false);

  const toggle = () => {
    Animated.timing(animatedHeight, {
      toValue: isVisible ? 0 : animHeight,
      duration: 300,
      useNativeDriver: false,
    }).start(() => setIsVisible(!isVisible));
  };

  return (
    <View style={{ width: '100%'}}>
      <TouchableOpacity onPress={toggle} style={{ marginHorizontal: 16, padding: 10, backgroundColor: '#333', borderRadius: 8, marginBottom: 8,}}>
        <Text style={{color: 'white', textAlign: 'center'}}>{isVisible ? 'Hide' : 'Show'} Storyly</Text>
      </TouchableOpacity>

      <Animated.View style={{ height: animatedHeight, width: '100%', overflow: 'hidden' }}>
        <View style={{height: animHeight}}>
          {children}
        </View>
      </Animated.View>
    </View>
  );
};
