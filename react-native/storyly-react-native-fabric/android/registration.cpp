#include <CoreComponentsRegistry.h>
#include CODEGEN_COMPONENT_DESCRIPTOR_H

namespace facebook {
namespace react {

void registerProviders() {
    auto providerRegistry = CoreComponentsRegistry::sharedProviderRegistry();
    providerRegistry->add(concreteComponentDescriptorProvider<StorylyReactNativeViewComponentDescriptor>());
    providerRegistry->add(concreteComponentDescriptorProvider<StorylyGroupViewComponentDescriptor>());
}

}
}

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *) {
    facebook::react::registerProviders();
    return JNI_VERSION_1_6;
}
