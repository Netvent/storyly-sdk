
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { HostComponent, ViewProps } from 'react-native';

interface StorylyGroupViewProps extends ViewProps {}

export default codegenNativeComponent<StorylyGroupViewProps>("StorylyGroupView", {}) as HostComponent<StorylyGroupViewProps>;