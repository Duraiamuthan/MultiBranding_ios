Branding
(UI,Build settings and functional)

 - *UI* 
   - App icon & other icons
   - iTunes Artwork
 - *Build settings*
   - App Name
   - Bundle Identifier
   - Provisioning profile
   - Code signing identity   
 - *Functional*
   - Brand specific URLs(login,logout,resource-fetch etc...)  

**Branding a source code into a another branded ipa using Terminal**

SourceCode2BrandedIpa.sh
 
The file is self-descriptive you can understand easily.
Just configure the values of variable in the file and call it like below

    sh SourceCode2BrandedIpa.sh

***FYI:***

With the above file you can do Branding for UI and Build Settings

For **functional branding** , you have to keep 

  -  Brand specific URLs

  -  Other inputs respective to a brand

in  a separate plist file so that this things also can be changed according to respective brand while building the app

[![Plist file][3]][3]

In coding side you can customise your application to read the values from plist like this

*Function defintion:*

    func getPlistFile()->Dictionary<String,AnyObject>? {
            var dictPlistFile:Dictionary<String,AnyObject>?
            if let path = NSBundle.mainBundle().pathForResource("plistfile", ofType: "plist") {
                if let dictValue = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject>       {
                    dictPlistFile=dictValue
                }
            }
            return dictPlistFile
        }

*Function calling:*

    var Value=getPlistFile()?["Key"]

You can change the values of the key according to brand using the *PlistBuddy* while building the app

Here is the syntax(shell)

    /usr/libexec/PlistBuddy -c "Set :Key Value" plistfile.plist

**Branding a existing ipa into a another branded ipa using Terminal**

*Ipa2BrandedIpa.sh*

The file is self-descriptive you can understand easily.
Just configure the values of variable in the file and call it like below

    sh Ipa2BrandedIpa.sh
    
***Branding using Jenkins***

We can effectively re-use the shell script here in jenkins

1.You have to parameterise all the variables in shell script in jenkins using ***Add Parameter***... like in the below screenshot I have done for one variable like that you have to do it for all others 

[![Paramterization][4]][4]

2.Choose ***Execute shell*** in the ***Build Step***

[![Build Step][5]][5]

3.Copy the script that is there in between *Creating the build based on configuration starts* and *Creating the build based on configuration ends* and paste it in *Execute Shell*
  [![Execute Shell][6]][6]

***Note:***

 - **Resource Rules**

   There is a known bug Regarding *ResourceRules* of Xcode in some versions while building and packaging the app through non-xcode interface.

  So it has to be run once to deactivate a validation for *resource rules* path in *xcode*.The resource rules path is *deprecated feature* and apple *doesn't accept apps* that comes with resource rules but if we build an app without using Xcode the validation error saying resource rules has not been found will arise to counter that we have to run the script only once.

   sh xcode_fix_PackageApplicationResourceRules.sh

- **Unlock keychain**

 Whenever you run Branding.sh in terminal it will prompt username and password as its accessing system keychain

 Whenever you run the Job in jenkins you will get "User Interaction Is Not Allowed" error 

 so to tackle this you have to follow the below steps

  - Open the Keychain Access
  - Right click on the private key
  - Select "Get Info"
  - Select "Access Control" tab
  - Click "Allow all applications to access this item"
  - Click "Save Changes"
  - Enter your password

- **Provisioning profile**

   if you ever get "No Matching Provisioning Profile Found" make sure you have double clicked and installed it via Xcode.

   The moment you install you'll see UUID.mobileprovision in `~/Library/MobileDevice/Provisioning Profiles/`
  
   This UUID is the value inside mobile provision that means the provisioning profile is installed.



  [1]: http://i.stack.imgur.com/QHwe3.png
  [2]: http://i.stack.imgur.com/dI0YM.png
  [3]: http://i.stack.imgur.com/0V3Fk.png
  [4]: http://i.stack.imgur.com/9iMWs.png
  [5]: http://i.stack.imgur.com/CI6I2.png
  [6]: http://i.stack.imgur.com/fT9gj.png
