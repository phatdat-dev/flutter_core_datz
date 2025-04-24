# @file: chmod +x build-release-script.sh && ./build-release-script.sh

# Build configuration
BuildAPK=true
BuildAAB=true
BuildIPA=true
UploadGoogle=false
UploadApple=true

TAG=v$(grep '^version:' pubspec.yaml | sed 's/version: //')

echo "--- TAG: $TAG ---"

if [ "$BuildAPK" = true ]; then
  echo "--- Flutter Clean... ---"
  flutter clean

  echo "--- Building release APK... ---"
  flutter build apk --release

  sleep 1 # Wait for app created
  echo "--- Renaming APK... ---"
  # Rename APK
  for file in build/app/outputs/flutter-apk/*.apk; do
    filename=$(basename "$file")
    mv "$file" "$(dirname "$file")/[${TAG}]${filename}"
  done
fi

if [ "$BuildAAB" = true ]; then
  echo "--- Building release AAB... ---"
  flutter build appbundle --release

  sleep 1 # Wait for app created
  echo "--- Renaming AAB... ---"
  # Rename AAB
  for file in build/app/outputs/bundle/release/*.aab; do
    filename=$(basename "$file")
    mv "$file" "$(dirname "$file")/[${TAG}]${filename}"
  done

  if [ "$UploadGoogle" = true ]; then
    echo "--- Uploading AAB to Google Play Store... ---"
    # Replace the following variables with your information
    SERVICE_ACCOUNT_JSON="env/vif-saigonwaterbus-b617445d6a31.json" # Path to your service account JSON file
    PACKAGE_NAME="tech.vietinfo.saigonwaterbus"            # Replace with your app's package name
    TRACK="internal"                        # Choose track: production, beta, alpha, or internal
    AAB_PATH="build/app/outputs/bundle/release/[${TAG}]app-release.aab"

    if [ ! -f "$SERVICE_ACCOUNT_JSON" ]; then
      echo "Error: Service account JSON file not found. Please provide the correct path."
      exit 1
    fi

    if [ ! -f "$AAB_PATH" ]; then
      echo "Error: AAB file not found at $AAB_PATH"
      exit 1
    fi

    ACCESS_TOKEN=$(curl -s -X POST -H "Content-Type: application/json" -d @"$SERVICE_ACCOUNT_JSON" "https://oauth2.googleapis.com/token" | jq -r .access_token)

    if [ "$ACCESS_TOKEN" == "null" ]; then
      echo "Error: Failed to retrieve access token. Check your service account JSON."
      exit 1
    fi

    echo access_token: $ACCESS_TOKEN
    exit 1
    UPLOAD_URL="https://www.googleapis.com/upload/androidpublisher/v3/applications/$PACKAGE_NAME/edits?uploadType=media"

    # Create a new edit
    EDIT_ID=$(curl -s -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d "{}" "https://www.googleapis.com/androidpublisher/v3/applications/$PACKAGE_NAME/edits" | jq -r .id)

    if [ "$EDIT_ID" == "null" ]; then
      echo "Error: Failed to create edit."
      exit 1
    fi

    # Upload the AAB
    UPLOAD_RESPONSE=$(curl -s -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -F "file=@$AAB_PATH" "$UPLOAD_URL/$EDIT_ID/bundles")

    if [[ "$UPLOAD_RESPONSE" == *"error"* ]]; then
      echo "Error: Failed to upload AAB. Response: $UPLOAD_RESPONSE"
      exit 1
    fi

    # Assign the release to the specified track
    TRACK_ASSIGN_RESPONSE=$(curl -s -X PUT -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d "{\"track\":\"$TRACK\",\"releases\":[{\"status\":\"completed\",\"versionCodes\":[${VERSION_CODE}]}]}" "https://www.googleapis.com/androidpublisher/v3/applications/$PACKAGE_NAME/edits/$EDIT_ID/tracks/$TRACK")

    if [[ "$TRACK_ASSIGN_RESPONSE" == *"error"* ]]; then
      echo "Error: Failed to assign track. Response: $TRACK_ASSIGN_RESPONSE"
      exit 1
    fi

    # Commit the edit
    COMMIT_RESPONSE=$(curl -s -X POST -H "Authorization: Bearer $ACCESS_TOKEN" "https://www.googleapis.com/androidpublisher/v3/applications/$PACKAGE_NAME/edits/$EDIT_ID:commit")

    if [[ "$COMMIT_RESPONSE" == *"error"* ]]; then
      echo "Error: Failed to commit edit. Response: $COMMIT_RESPONSE"
      exit 1
    fi

    echo "--- Successfully uploaded AAB to Google Play Store on track: $TRACK ---"
  fi
fi

if [ "$BuildIPA" = true ]; then
  echo "--- Installing pods... ---"
  cd ios && pod install --repo-update && cd ..

  echo "--- Building release IPA... ---"
  flutter build ipa --release

  sleep 1 # Wait for app created
  echo "--- Renaming IPA... ---"
  # Rename IPA
  for file in build/ios/ipa/*.ipa; do
    filename=$(basename "$file")
    mv "$file" "$(dirname "$file")/[${TAG}]${filename}"
  done

  if [ "$UploadApple" = true ]; then
    echo "--- IOS - Uploading IPA to App Store Connect... ---"
    xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey YOUR_API_KEY --apiIssuer YOUR_API_ISSUER 
  fi
fi

# https://developers.google.com/identity/protocols/oauth2/service-account#httprest
# https://medium.com/nerd-for-tech/ci-cd-for-android-using-github-actions-and-gradle-play-publisher-448bd8e42774