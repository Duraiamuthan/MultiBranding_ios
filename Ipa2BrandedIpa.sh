#Author: Durai Amuthan(h.duraiamuthan@gmail.com)
#This is to achieve multiple branding of the ipa
#Reading the configuration for the branding

appName="Give the app name here"

bundleIdentifier="Give the bundle identifier"

teamIdentifier="Give the team identfier"

applicationIdentifier=$teamIdentifier.$bundleIdentifier

provisioningProfilePath="absolute path of mobile provision"

version="Give the version"

iconsPath="Give the path of app icons"

codeSigner="Give code signer name"

#uncompressing the .ipa to .app
mv *.ipa temp.zip

unzip temp.zip

cd Payload

#Reading the existing entitlement of the app
codesign -d --entitlements - *.app > entitlements.plist

value=`cat entitlements.plist`

value=${value:6}

echo $value > entitlements.plist

#Injecting the configuration


/usr/libexec/PlistBuddy -c "Set :application-identifier $applicationIdentifier" entitlements.plist

/usr/libexec/PlistBuddy -c "Set :com.apple.developer.team-identifier $teamIdentifier" entitlements.plist

/usr/libexec/PlistBuddy -c "Set :get-task-allow false" entitlements.plist

/usr/libexec/PlistBuddy -c "Set :keychain-access-groups:0 $applicationIdentifier" entitlements.plist

cp $provisioningProfilePath `pwd`

cp -R `pwd`/*.mobileprovision *.app/embedded.mobileprovision

cp -R $iconsPath/*.png `pwd`/*.app

cp -R $iconsPath/iTunesArtwork@2x `pwd`/*.app

cp -R $iconsPath/iTunesArtwork `pwd`/*.app

cd *.app

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $bundleIdentifier" info.plist

/usr/libexec/PlistBuddy -c "Set :CFBundleName $appName" info.plist

/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $appName" info.plist  

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $version" info.plist

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $version" info.plist

cd ..

#Signing application framework
codesign -f -s "$codeSigner" *.app/Frameworks/*

#Signing application
codesign -f -s "$codeSigner" '--entitlements' `pwd`'/entitlements.plist' '*.app'

rm entitlements.plist

rm *.mobileprovision

cd ..

#Packaging the .app to .ipa
zip -r Payload.zip Payload/

mv Payload.zip $appName.ipa

rm temp.zip

rm -rf Payload