# Launch Screen Assets

These PNGs are exact-size exports of
`assets/brand/logos/creaturely-mark-primary.svg`, the approved light-background
Creaturely mark.

Regenerate them from the SVG source rather than resizing an existing PNG:

```sh
sips -s format png -z 160 160 \
  assets/brand/logos/creaturely-mark-primary.svg \
  --out ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png
sips -s format png -z 320 320 \
  assets/brand/logos/creaturely-mark-primary.svg \
  --out ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png
sips -s format png -z 480 480 \
  assets/brand/logos/creaturely-mark-primary.svg \
  --out ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png
```
