# Fastlane tests

This code is made to check out how [Fastlane](https://fastlane.tools/) behaves in an enviroment where the xCode project manages multiple schemes and some of those belongs to different signing groups.


## Obtaining an ipa file

In order to obtain an \*.ipa file, there should be a way to perform the Archive action present under xCode product menu.

### match

This action allows you to manage certificates and provisioning profiles by means of a git repository, additional to the protection that repository may have, match comes with the option to password protect those files.

### disable_automatic_code_signing

This action modifies the way xCode handles code signing without actually operating the graphical interface, just make sure to set the correct values here, otherwise you may run in trouble.

### gym

This action is in charge of building an \*.ipa file for distribution, provided the code signing values are correctly setted and the code is building correctly.

## Uploading to TestFlight

Having the list of all the generated \*.ipa files, the only thing to do is perform the upload process to TestFlight.

### pilot

This action uploads a generated \*.ipa file to TestFlight, when working with multiple teams don't forget to set up the environment variables `FASTLANE_ITC_TEAM_ID` and `FASTLANE_ITC_TEAM_NAME` accordingly!
