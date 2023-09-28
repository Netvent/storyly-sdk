package com.storylyreactnative

import android.app.Activity
import android.net.Uri
import android.view.View
import com.facebook.react.common.MapBuilder
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.StorylyReactNativeViewManagerDelegate
import com.facebook.react.viewmanagers.StorylyReactNativeViewManagerInterface
import com.facebook.soloader.SoLoader
import com.storylyreactnative.data.STEvent
import com.storylyreactnative.data.createSTRCart
import com.storylyreactnative.data.createSTRProductItem
import com.storylyreactnative.data.createStorylyBundle
import com.storylyreactnative.data.jsonStringToMap

@ReactModule(name = StorylyReactNativeViewManager.NAME)
class StorylyReactNativeViewManager : ViewGroupManager<STStorylyView>(),
    StorylyReactNativeViewManagerInterface<STStorylyView> {

    private val _delegate: ViewManagerDelegate<STStorylyView> by lazy {
        StorylyReactNativeViewManagerDelegate(this)
    }

    override fun getDelegate(): ViewManagerDelegate<STStorylyView> = _delegate

    override fun getName(): String = NAME

    public override fun createViewInstance(context: ThemedReactContext): STStorylyView {
        return STStorylyView(context)
    }

    override fun addView(parent: STStorylyView?, child: View?, index: Int) {
        parent?.onAttachCustomReactNativeView(child, index)
    }

    @ReactProp(name = "storylyConfig")
    override fun setStorylyConfig(view: STStorylyView?, value: String?) {
        val activity = view?.activity as? Activity ?: return

        val rawConfig = value?.let { jsonStringToMap(it) } ?: return
        val bundle = createStorylyBundle(activity, rawConfig)
        view.apply {
            storylyView = bundle?.storylyView
            storyGroupViewFactory = bundle?.storyGroupViewFactory?.apply {
                dispatchEvent = view::dispatchEvent
            }
        }
    }

    override fun resumeStory(view: STStorylyView?) {
        view?.storylyView?.resumeStory()
    }

    override fun pauseStory(view: STStorylyView?) {
        view?.storylyView?.pauseStory()
    }

    override fun closeStory(view: STStorylyView?) {
        view?.storylyView?.closeStory()
    }

    override fun openStory(view: STStorylyView?, raw: String?) {
        val map = raw?.let { jsonStringToMap(it) } ?: return
        val url = (map["url"] as? String)?.let {  Uri.parse(it) } ?: return
        view?.storylyView?.openStory(url)
    }

    override fun openStoryWithId(view: STStorylyView?, raw: String?) {
        val map = raw?.let { jsonStringToMap(it) } ?: return
        val groupId = map["groupId"] as? String ?: return
        val storyId = map["storyId"] as? String ?: return
        view?.storylyView?.openStory(groupId, storyId)
    }

    override fun hydrateProducts(view: STStorylyView?, raw: String?) {
        val map = raw?.let { jsonStringToMap(it) } ?: return
        val productItems = (map["products"] as? List<Map<String, Any?>>)?.map { createSTRProductItem(it) } ?: return
        view?.storylyView?.hydrateProducts(productItems)
    }

    override fun updateCart(view: STStorylyView?, raw: String?) {
        val map = raw?.let { jsonStringToMap(it) } ?: return
        val cart = (map["cart"] as? Map<String, Any?>)?.let { createSTRCart(it) } ?: return
        view?.storylyView?.updateCart(cart)
    }

    override fun approveCartChange(view: STStorylyView?, raw: String?) {
        val map = raw?.let { jsonStringToMap(it) } ?: return
        val responseId = (map["responseId"] as? String) ?: return
        val cart = (map["cart"] as? Map<String, Any?>)?.let { createSTRCart(it) }
        cart?.let {
            view?.approveCartChange(responseId, it)
        } ?: run {
            view?.approveCartChange(responseId)
        }
    }

    override fun rejectCartChange(view: STStorylyView?, raw: String?) {
        val map = raw?.let { jsonStringToMap(it) } ?: return
        val responseId = (map["responseId"] as? String) ?: return
        val failMessage = (map["failMessage"] as? String) ?: return
        view?.rejectCartChange(responseId, failMessage)
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        val builder = MapBuilder.builder<String, Any>()
        STEvent.Type.values().forEach {
            builder.put(it.rawName, MapBuilder.of("registrationName", it.rawName))
        }
        return builder.build()
    }
    companion object {
        const val NAME = "StorylyReactNativeView"

        init {
            if (BuildConfig.CODEGEN_MODULE_REGISTRATION != null) {
                SoLoader.loadLibrary(BuildConfig.CODEGEN_MODULE_REGISTRATION)
            }
        }
    }
}
