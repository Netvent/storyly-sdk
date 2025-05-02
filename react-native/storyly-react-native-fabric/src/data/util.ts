import { PixelRatio, Platform } from "react-native";

export type Optional<T> = T | null | undefined;


export const convertFromNative = (size: number) => {
    return Platform.OS === 'android' ? size / PixelRatio.get() : size
}
  