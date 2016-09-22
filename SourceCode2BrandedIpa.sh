#Author: Durai Amuthan(h.duraiamuthan@gmail.com)
#This is to achieve multiple branding of an iOS app by configuring the variables below

#************ Configuring the brand starts ************

PathOfProjectDirectory="Directory path where .xcworkspace or .xcodeproj exists.It has to be a absolute path"

PathOfInfoPlist=$PathOfProjectDirectory/"directory or relative path where info.plist exists"

#Note: Make sure proper naming conventions of file has been followed
PathOfNewIcons="Path to icons where new iTunesArtwork and application icon exixts"

#Path to asset resource where you have kept your application icon.
PathOfAppIconSet=$PathOfProjectDirectory/XxYyZz/Icon.xcassets/AppIcon.appiconset

PathToApp="Path where do you want the branded .app file has to be kept"

PathToIpa="Path where do you want the .ipa file has to kept"

#Cocoapods project or project that involves more than one modules are scheme based
isWorkspaceBased=true

#Path of the Project (.xcodeproj) - applicable for workspace(.xcworkspace) based project
PathofProjectFile=$PathOfProjectDirectory/XxYyZz.xcodeproj

#Path of the Workspace (.xcworkspace)
PathofWorkspaceFile=$PathOfProjectDirectory/XxYyZz.xcworkspace

#Name of the target - applicable only for non-workspace(.xcodeproj)  based projects
Target=XxYyZz

#Scheme of the iOS app
Scheme=XxYyZz

#To ascertain Cocoapods has been used or not
isCocoaPodsBased=true

#Configuration of the app (Debug -(Development) or Release(Adhoc or Distribution))
Config=Release

#For giving access to signing idetity found in KeyChain
LoginKeychainPath=/Users/Shared/Jenkins/Library/Keychains/login.keychain
LoginKeyChainPassword=xxyyzz

#Name of the code signing identity.You can find the name in Keychain or xcode build setting
CodeSigningIdentity='iPhone Distribution: Xx Yy Zz Limited (3Z5MHUYJ2L)'

PathToMobileProvision="Absolute Path of the provisioning profile"

#UUID value found inside Provisioning profile has to be given
#Do not forget to install provisiong profile in the system
ProvisioningProfileIdentity=6e6506e9-8233-4886-9084-zf21e8f8bbae

#Bundle identifier of the app
BundleIdentifier=com.xxyy.zz

AppVersion="Branded AppVersion of the app"

Appname="Branded App Name"

#************ Configuring the brand ends ************

#** Creatting the build based on configuration starts **

cd $PathOfInfoPlist
echo "****************** Setting App Name ******************"
/usr/libexec/PlistBuddy -c "Set :CFBundleName $Appname" info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $Appname" info.plist

cd $PathOfProjectDirectory
echo "****************** Setting AppVersion ******************"
/usr/bin/agvtool new-marketing-AppVersion $AppVersion
/usr/bin/agvtool new-AppVersion -all $AppVersion

echo "****************** Changing app icons & iTunes Artwork ******************"
cp -R $PathOfNewIcons/*.png $PathOfAppIconSet
echo "App icons has been changed at $PathOfNewIcons"
cp -R $PathOfNewIcons/iTunesArtwork@2x $PathOfProjectDirectory/XxYyZz
cp -R $PathOfNewIcons/iTunesArtwork $PathOfProjectDirectory/XxYyZz
echo "iTunesArtwork has been changed at $PathOfProjectDirectory"

#Unlock login keychain
security unlock-keychain -p $LoginKeyChainPassword $LoginKeychainPath
if $isCocoaPodsBased == 'true'
then
echo "****************** Installing Cocoapods **********************"
/usr/local/bin/pod install
echo "Cocoapods has been installed"
fi

echo "****************** Creating .app ******************"
if $isWorkspaceBased == 'true'
then
/usr/bin/xcodebuild -scheme $Scheme -workspace $PathofWorkspaceFile -configuration $Config clean build CONFIGURATION_BUILD_DIR=$PathToApp "CODE_SIGN_IDENTITY=$CodeSigningIdentity" "PRODUCT_BUNDLE_IDENTIFIER=$BundleIdentifier" "PROVISIONING_PROFILE=$ProvisioningProfileIdentity"
else
/usr/bin/xcodebuild -target $Target -project $PathofProjectFile -configuration $Config clean build CONFIGURATION_BUILD_DIR=$PathToApp "CODE_SIGN_IDENTITY=$CodeSigningIdentity" "PRODUCT_BUNDLE_IDENTIFIER=$BundleIdentifier" "PROVISIONING_PROFILE=$ProvisioningProfileIdentity"
fi
echo ".app has been generated at $PathToApp"

echo "****************** Creating .ipa *******************"
/usr/bin/xcrun -sdk iphoneos PackageApplication -v $PathToApp/XxYyZz.app -o $PathToIpa/$Appname.ipa --embed $PathToMobileProvision --sign "$CodeSigningIdentity"
echo "$Appname.ipa has been generated at $PathToIpa"

#** Creatting the build based on configuration ends **
#If you want some other icons also to be changed besides App Icon and iTunesArtwork
#use `cp` command e.g
#cp path/to/source path/to/destination
#To know more info do `cp man`