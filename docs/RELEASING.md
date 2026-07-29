# Building and distributing Creaturely

Creaturely uses two GitHub Actions workflows:

- [Creaturely CI](../.github/workflows/ci.yml) runs generation checks,
  formatting, analysis, unit/widget tests, the Android integration journey, an
  Android debug build, and an unsigned iOS simulator build on pushes and pull
  requests.
- [Creaturely Release](../.github/workflows/release.yml) runs release checks,
  builds signed Android and iOS artifacts, stores them for 90 days as workflow
  artifacts, and creates or refreshes a durable draft GitHub Release.

The release workflow is continuous delivery of a reviewed release candidate.
It does not automatically submit an app for public store review. The first
store setup requires legal agreements, app records, privacy disclosures,
screenshots, tester configuration, and other owner decisions that do not
belong in source control.

## One-time GitHub setup

In the GitHub repository:

1. Open **Settings > Environments** and create an environment named
   `mobile-release`.
2. Restrict deployment branches/tags to release tags such as `v*`.
3. Add a required reviewer if the repository plan supports it. Environment
   secrets are not exposed to a release job until its protection rules pass.
4. Add the Android and Apple secrets listed below to this environment.

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
   | `ANDROID_KEYSTORE_BASE64` | Base64 output for the upload keystore |
   | `ANDROID_KEYSTORE_PASSWORD` | Keystore password |
   | `ANDROID_KEY_ALIAS` | Upload-key alias, such as `upload` |
   | `ANDROID_KEY_PASSWORD` | Password for that alias |

For a signed local build from Android Studio or the Flutter CLI, copy
[`android/key.properties.example`](../android/key.properties.example) to
`android/key.properties` and replace every placeholder. That private file and
common keystore extensions are ignored by Git.

Without private signing configuration, local release-mode builds continue to
use the debug key for development convenience. The GitHub release workflow
sets `CREATURELY_REQUIRE_RELEASE_SIGNING=true`, so its distribution build fails
instead of silently using the debug key.

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
artifacts are wanted.

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

## Is Fastlane required?

No. Creaturely's current workflow deliberately uses the underlying tools
directly:

- Flutter and Gradle build the Android AAB/APK.
- Flutter and Xcode's `xcodebuild` create the iOS archive/IPA.
- GitHub Actions coordinates verification, signing, artifact storage, and the
  draft release.
- Play Console and Transporter/Xcode/App Store Connect handle the first store
  deliveries.

This is the smallest stack for learning the release process and diagnosing
signing failures. Fastlane is an optional automation layer over many of these
same tools and store APIs. It becomes valuable when repeated manual work is
the problem: uploading every beta, promoting Play tracks, managing store
metadata/screenshots, or sharing reusable release commands between local and
CI environments. It also adds a Ruby/Bundler dependency and another
configuration surface, so Creaturely should adopt it only when a concrete lane
will replace repeated work.

Alternatives include:

| Approach | Best fit | Trade-off |
| --- | --- | --- |
| GitHub Actions plus native tools (current) | One Flutter repo already hosted on GitHub | Store upload steps are configured explicitly |
| Fastlane inside GitHub Actions | Repeated Android and iOS store operations | Ruby dependencies and Fastlane configuration |
| Xcode Cloud | Deeply integrated iOS/TestFlight delivery | Apple-only; Android still needs another pipeline |
| Codemagic or Bitrise | Managed mobile-specific signing and store UI | Another hosted service, configuration, and possible cost |
| Direct App Store Connect/Google Play APIs | Fully customized automation | Most engineering and credential-management work |

For Creaturely v1, keep GitHub Actions and perform the first Play/TestFlight
uploads manually. After both store records have successfully accepted a build,
automate uploads to internal testing—not production—and retain human approval
for promotion and public rollout.

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

Store upload automation can be added after both console accounts and their
first apps are established. Keep that as separate, approval-gated deployment
jobs with least-privilege Play service-account/App Store Connect credentials.
Uploading a binary never bypasses TestFlight processing, platform review, or a
deliberate production rollout.

## Official references

- [GitHub workflow artifacts](https://docs.github.com/en/actions/concepts/workflows-and-actions/workflow-artifacts)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
- [GitHub deployment environments](https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments)
- [Flutter Android release guide](https://docs.flutter.dev/deployment/android)
- [Android Play App Signing](https://developer.android.com/studio/publish/app-signing)
- [Flutter iOS release guide](https://docs.flutter.dev/deployment/ios)
- [Apple App Store Connect build uploads](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)
- [Fastlane setup](https://docs.fastlane.tools/getting-started/ios/setup/)
- [Apple Xcode Cloud](https://developer.apple.com/documentation/Xcode/Xcode-Cloud)
- [Google Play Developer API](https://developers.google.com/android-publisher)
