# Building and distributing Creaturely

Creaturely uses two GitHub Actions workflows:

- [Creaturely CI](../.github/workflows/ci.yml) runs generation checks,
  formatting, analysis, unit/widget tests, the Android integration journey, an
  Android debug build, and an unsigned iOS simulator build on pushes and pull
  requests.
- [Creaturely Release](../.github/workflows/release.yml) runs release checks,
  builds signed Android and iOS artifacts, stores them for 90 days as workflow
  artifacts, creates or refreshes a durable draft GitHub Release, and can
  optionally use Fastlane to deliver that exact build to Google Play Internal
  and TestFlight.

The release workflow is continuous delivery of a reviewed release candidate.
Store delivery runs only from a manual workflow dispatch with **Deploy beta**
selected and after approval of the `mobile-beta` environment. Pushing a tag
never uploads to a store, and no lane submits an app for public review. The
first store setup still requires legal agreements, app records, privacy
disclosures, screenshots, tester configuration, and other owner decisions
that do not belong in source control.

## One-time GitHub setup

In the GitHub repository:

1. Open **Settings > Environments** and create `mobile-release` for signing
   credentials and `mobile-beta` for store API credentials.
2. Allow release tags such as `v*` and the default branch used to start manual
   workflows. Manual dispatch runs from that branch even though the workflow
   validates an existing tag and checks out its immutable commit.
3. Add a required reviewer if the repository plan supports it. Environment
   secrets are not exposed to a release or deployment job until its protection
   rules pass.
4. Add the Android and Apple secrets listed below to the environment named in
   each section.

Never place signing keys, certificate passwords, provisioning profiles, or
store API credentials in the repository, issue attachments, release notes, or
workflow logs.

## Android signing

Google Play requires signed Android artifacts. With Play App Signing, keep a
separate upload key and let Google hold the app-signing key used for Play
downloads.

1. Create the Play Console app with package name
   `com.vector42.creaturely` and enroll it in Play App Signing.
2. Create and securely back up an upload keystore. For example:

   ```sh
   keytool -genkeypair -v \
     -keystore upload-keystore.jks \
     -keyalg RSA \
     -keysize 2048 \
     -validity 10000 \
     -alias upload
   ```

3. Convert the keystore to a single-line Base64 value:

   ```sh
   openssl base64 -A -in upload-keystore.jks
   ```

4. Add these `mobile-release` environment secrets:

   | Secret | Value |
   | --- | --- |
   | `CREATURELY_ANDROID_KEYSTORE_BASE64` | Base64 output for the upload keystore |
   | `CREATURELY_ANDROID_KEYSTORE_PASSWORD` | Keystore password |
   | `CREATURELY_ANDROID_KEY_ALIAS` | Upload-key alias, such as `upload` |
   | `CREATURELY_ANDROID_KEY_PASSWORD` | Password for that alias |

For a signed local build from Android Studio or the Flutter CLI, copy
[`android/key.properties.example`](../android/key.properties.example) to
`android/key.properties` and replace every placeholder. That private file and
common keystore extensions are ignored by Git.

Without private signing configuration, local release-mode builds continue to
use the debug key for development convenience. The GitHub release workflow
sets `CREATURELY_REQUIRE_RELEASE_SIGNING=true`, so its distribution build fails
instead of silently using the debug key.

### Google Play beta delivery

Fastlane's `android beta` lane uploads an already-signed AAB to the
**Internal testing** track. It deliberately skips store metadata, changelogs,
images, and screenshots, so a beta build cannot unexpectedly replace the
listing.

Google Play must already contain the Creaturely app and at least one
owner-uploaded build before its publishing API accepts Fastlane uploads.
After that first upload:

1. Enable the Google Play Developer API for the Play-linked Google Cloud
   project.
2. Create a dedicated service account and grant it only the Play Console
   permissions needed to manage internal-testing releases for Creaturely. Do
   not grant production-release permission.
3. Download its JSON credential and convert it to a single-line Base64 value:

   ```sh
   openssl base64 -A -in google-play-service-account.json
   ```

4. Add the result as
   `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64` in `mobile-beta`.

Fastlane also supports Google Workload Identity Federation. That is a useful
future hardening step because it removes the long-lived JSON key; the initial
workflow uses the simpler protected-environment secret while the owner learns
the store setup.

## Apple signing

An App Store/TestFlight IPA requires an Apple Developer team, an Apple
Distribution certificate with its private key, and an App Store provisioning
profile whose entitlements match Creaturely.

1. Finish the local Xcode setup, then confirm Flutter can use it:

   ```sh
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   flutter doctor -v
   ```

   Opening Xcode once also presents the license and additional-component
   prompts that must be completed before command-line builds work.

2. Register `com.vector42.creaturely` in the Apple Developer portal.
3. Enable the required iCloud/CloudKit capability and use the container
   declared in [`Runner.entitlements`](../ios/Runner/Runner.entitlements).
4. Create the Creaturely app record in App Store Connect.
5. Create an Apple Distribution certificate. Export the certificate and
   private key from Keychain Access as a password-protected `.p12`.
6. Create and download an App Store provisioning profile for
   `com.vector42.creaturely`. The profile must include Creaturely's
   capabilities.
7. Convert both files to single-line Base64 values:

   ```sh
   openssl base64 -A -in CreaturelyDistribution.p12
   openssl base64 -A -in CreaturelyAppStore.mobileprovision
   ```

8. Add these `mobile-release` environment secrets:

   | Secret | Value |
   | --- | --- |
   | `IOS_DISTRIBUTION_CERTIFICATE_BASE64` | Base64 output for the `.p12` |
   | `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD` | Password used when exporting the `.p12` |
   | `IOS_PROVISIONING_PROFILE_BASE64` | Base64 output for the provisioning profile |
   | `IOS_TEAM_ID` | Ten-character Apple Developer team ID |

The workflow imports these into a temporary keychain, confirms that the
profile's team and bundle ID match, creates the signed archive/IPA, and removes
the temporary keychain and installed profile even when the job fails.

### TestFlight beta delivery

Fastlane's `ios beta` lane uploads the signed IPA, waits for App Store Connect
processing, and assigns the build to an internal TestFlight group. It never
enables external distribution or submits beta review.

1. In App Store Connect, create an internal group named
   `Creaturely Internal` and add the intended testers.
2. Create a team App Store Connect API key with the **App Manager** or
   **Admin** role. Fastlane can upload with a Developer key, but it needs the
   higher role to update build/tester assignments.
3. Download the `.p8` private key once and convert it to a single-line Base64
   value:

   ```sh
   openssl base64 -A -in AuthKey_KEY_ID.p8
   ```

4. Add these `mobile-beta` environment secrets:

   | Secret | Value |
   | --- | --- |
   | `APP_STORE_CONNECT_KEY_ID` | API key ID |
   | `APP_STORE_CONNECT_ISSUER_ID` | API issuer ID |
   | `APP_STORE_CONNECT_PRIVATE_KEY_BASE64` | Base64 output for the `.p8` key |

The workflow defaults to the group name `Creaturely Internal`. If a different
name is preferred, add a non-secret `TESTFLIGHT_INTERNAL_GROUP` variable to the
`mobile-beta` environment.

## Local tool readiness

Creaturely uses Flutter 3.44's default Swift Package Manager integration. A
successful `flutter build ios --simulator --debug --no-codesign` confirms that
the current plugins resolve without CocoaPods, so Flutter Doctor's CocoaPods
warning does not block this repository. Install CocoaPods only if a future
plugin forces Flutter to fall back to it.

Accept the outstanding Android SDK licenses before Android release work:

```sh
flutter doctor --android-licenses
flutter doctor -v
```

Fastlane is pinned through Bundler and requires Ruby 3.3 or newer. On an Apple
Silicon Mac, one straightforward setup is:

```sh
brew install ruby@3.4
export PATH="/opt/homebrew/opt/ruby@3.4/bin:$PATH"
bundle install
bundle exec fastlane lanes
```

The two beta lanes consume artifacts built by Flutter; they do not rebuild
them. A local Android upload, for example, uses a credential file kept outside
the repository:

```sh
CREATURELY_ANDROID_AAB_PATH=build/app/outputs/bundle/release/app-release.aab \
GOOGLE_PLAY_CREDENTIALS_PATH=/secure/path/google-play-service-account.json \
bundle exec fastlane android beta
```

## Create a release candidate

1. Set the intended public version in `pubspec.yaml`, for example:

   ```yaml
   version: 1.0.0+1
   ```

2. Merge and verify the release commit.
3. Create and push an annotated tag whose version matches the part before `+`:

   ```sh
   git tag -a v1.0.0 -m "Creaturely 1.0.0"
   git push origin v1.0.0
   ```

The workflow accepts only `vMAJOR.MINOR.PATCH` tags and confirms the tag matches
`pubspec.yaml`. GitHub's run number and retry attempt produce a monotonically
increasing numeric store build number, so retrying a failed build does not
reuse an already uploaded Apple/Google build number.

An existing tag can also be rebuilt from **Actions > Creaturely Release > Run
workflow**. Disable **Create draft release** there when only temporary workflow
artifacts are wanted. Select **Deploy beta** only when the tagged build should
also be delivered to Play Internal and TestFlight. The protected
`mobile-beta` environment provides a final human approval before either
upload begins.

Successful runs contain:

| Artifact | Intended use |
| --- | --- |
| `creaturely-VERSION+BUILD.aab` | Google Play internal/closed/open/production tracks |
| `creaturely-VERSION+BUILD.apk` | Direct installation for controlled Android QA |
| `creaturely-VERSION+BUILD-android-mapping.txt` | Android R8 stack-trace deobfuscation |
| `creaturely-VERSION+BUILD-android-native-symbols.zip` | Android native crash symbolication |
| `creaturely-VERSION+BUILD.ipa` | Upload to App Store Connect/TestFlight |
| `creaturely-VERSION+BUILD-dSYMs.zip` | Apple crash-symbolication archive |
| `SHA256SUMS-*.txt` | Integrity checks for the generated files |

Download them from the workflow run's **Artifacts** section. They expire there
after 90 days, which is GitHub's maximum for a public repository. The workflow
also attaches them to a draft GitHub Release. Release assets have no Actions
artifact expiry and remain associated with the release until someone deletes
the asset, release, or repository. Review the files and generated notes before
publishing that draft.

Keep every shipped version's tag, store binary, checksums, Android mapping and
native symbols, and Apple dSYMs for the lifetime of the app. GitHub Releases are
the primary archive; maintain an independent owner-controlled backup as
disaster recovery rather than treating any single hosted service as literally
permanent.

## What Fastlane owns

Fastlane complements rather than replaces GitHub Actions:

- Flutter and Gradle build the Android AAB/APK.
- Flutter and Xcode's `xcodebuild` create the iOS archive/IPA.
- GitHub Actions coordinates verification, signing, immutable artifact storage,
  release checksums, and approval boundaries.
- Fastlane uploads those exact artifacts to Play Internal and TestFlight.
- Play Console and App Store Connect retain the human-controlled promotion and
  public-review steps.

The pinned [`Fastfile`](../fastlane/Fastfile) refuses missing artifacts and
credentials, fixes Android delivery to the internal track, and fixes iOS
delivery to internal TestFlight. Ruby dependencies are locked in
[`Gemfile.lock`](../Gemfile.lock), and CI parses every lane on each change.

Fastlane can also automate store screenshots, but it cannot infer a useful
Flutter screenshot journey. Its iOS `snapshot` feature drives XCUITest and its
Android `screengrab` feature drives Espresso. Before enabling screenshot upload,
Creaturely needs a deterministic synthetic journal, finalized store copy,
approved device sizes, and UI tests that never expose a keeper's real health
data. Once that harness exists, screenshot generation and upload can be added
as separate approval-gated lanes without changing the beta lanes.

## Distribute Android

Use the `.aab` for Google Play. For the first release:

1. Complete the Play Console dashboard, store listing, privacy/Data safety
   declarations, content rating, countries, contact details, and testing
   requirements.
2. Create an **Internal testing** release and upload the `.aab`.
3. Add testers, verify installation, notifications, backup/restore, and file
   flows on physical devices.
4. Promote a tested build through the appropriate closed/open or production
   track and submit it for review.

The `.apk` is convenient for owner-controlled QA outside Play. If Play uses a
different app-signing key from the upload key, that APK and the Play-delivered
app are different signing channels: a tester may need to uninstall one before
installing the other. Do not treat an upload-key-signed GitHub APK as the normal
public update channel.

## Distribute iOS

The `.ipa` uses an App Store distribution profile and is intended for App Store
Connect, not ordinary public sideloading.

1. On a Mac, upload it with Apple's Transporter app, Xcode Organizer, or
   `xcrun altool` using an App Store Connect API key:

   ```sh
   xcrun altool \
     --upload-app \
     --type ios \
     --file creaturely-1.0.0+101.ipa \
     --apiKey YOUR_KEY_ID \
     --apiIssuer YOUR_ISSUER_ID
   ```

2. Wait for App Store Connect to process the build.
3. Add it to a TestFlight internal group. External testing can require beta
   review.
4. Complete App Store metadata, privacy answers, screenshots, availability,
   agreements, and compliance questions.
5. Select the tested build and submit it to App Review.

The Fastlane lane automates these upload and internal-group steps after the
first App Store Connect setup. Uploading a binary never bypasses TestFlight
processing, platform review, or a deliberate production rollout.

## Official references

- [GitHub workflow artifacts](https://docs.github.com/en/actions/concepts/workflows-and-actions/workflow-artifacts)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
- [GitHub deployment environments](https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments)
- [Flutter Android release guide](https://docs.flutter.dev/deployment/android)
- [Android Play App Signing](https://developer.android.com/studio/publish/app-signing)
- [Flutter iOS release guide](https://docs.flutter.dev/deployment/ios)
- [Flutter continuous delivery guide](https://docs.flutter.dev/deployment/cd)
- [Flutter Swift Package Manager guide](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers)
- [Apple App Store Connect build uploads](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)
- [Fastlane GitHub Actions guide](https://docs.fastlane.tools/best-practices/continuous-integration/github/)
- [Fastlane Play upload](https://docs.fastlane.tools/actions/upload_to_play_store/)
- [Fastlane TestFlight upload](https://docs.fastlane.tools/actions/upload_to_testflight/)
- [Apple Xcode Cloud](https://developer.apple.com/documentation/Xcode/Xcode-Cloud)
- [Google Play Developer API](https://developers.google.com/android-publisher)
