# ProvisionSPFx
How to programatically add SPFx web parts to multiple sites

New SPFx development model is a great tool, however it has some really annoying limits. One of them is unavailabilty of creating site templates containing new client side web parts. Thanks to PnP team there is a way to programatically create modern pages and manipulating SPFx web parts (Chris O'Brien did an excellent overview of this feature). Since Chris post Microsoft released an option of tenant web part deployment, so things are more simple right now.

In order to programatically add SPFx web part to multiple sites you should:

1. Set checkbox "Make this solution available to all sites in the organization"

During .sppkg file deployment to app catalog you'll be prompted the following dialog (note that
checkbox appears if attribute "skipFeatureDeployment" in your solution manifest is set to true)

2. Execute ProvisionSPFxWP.ps1 script

3. Web part successfully added to all sites!


http://ivanovdka.blogspot.ru/2018/01/how-to-programatically-add-spfx-web.html 
