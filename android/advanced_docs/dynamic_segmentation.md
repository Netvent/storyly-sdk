### Storyly Dynamic Segmentation

If you would like to decrease network bandwidth and dynamically manage your segments in your application, this feature can be used.

```
dynamicSegmentation = true
```

Your story groups are started being filtered in SDK rather than backend. In default behavior, filtering algorithm works the same way with static segmentation.

If you would like to customize filtering function according to your own business needs, you can override

```
dynamicSegmentattionFilterFunc: ((Set<String>?, Set<String>?) -> Boolean)
```
