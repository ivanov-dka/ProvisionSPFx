###############
## 
## Add a new client side welcome page to all webs of site collection using PnP PowerShell comandlets
## 
########

##tenant name
$tenant = "tenant";
#sitecollection name
$siteName = "siteName";
#desired page name
$pagename = "Welcome";
#grab a title from solution manifest .json file
$webPartName = "webPartName";
Connect-PnPOnline -Url https://$tenant.sharepoint.com/sites/$siteName -Credentials (Get-Credential)
foreach ($web in Get-PnPSubWebs -Recurse)
{   
    #To enable site pages at web
    $siteFeature = Get-PnPFeature -Identity B6917CB1-93A0-4B97-A84D-7CF49975D4EC -Scope Web -Web $web
   
    if([string]::IsNullOrEmpty($siteFeature)) {
        Enable-PnPFeature -Identity B6917CB1-93A0-4B97-A84D-7CF49975D4EC -Scope Web -Web $web
    }

    $page = Add-PnPClientSidePage -Name $pagename -Web $web

    if($page -eq $null)
    {
        Write-Host Page can not be added to site $web.Title! -ForegroundColor Red
        continue;
    }

    #Add new section to a page (Site Pages feature has to be activated)
    Add-PnPClientSidePageSection -Page $page -SectionTemplate OneColumn -Order 1 -Web $web

    #If web part installed on a site or globally deployed it should be available to add
    $components = $page.AvailableClientSideComponents() 
    $wpToAdd = $components | Where-Object { $_.ComponentType -eq 1 -and $_.Name -eq $webPartName }

    if($wpToAdd -eq $null)
    {
        Write-Host WebPart called $webPartName was not found! -ForegroundColor Red
        return;
    }

    $clientWP = new-object OfficeDevPnP.Core.Pages.ClientSideWebPart($wpToAdd);

    #Add webpart to page
    $page.AddControl($clientWP);

    #Set the new clientside page as HomePage
    Set-PnPHomePage -RootFolderRelativeUrl SitePages/$pagename.aspx -Web $web

    $page.Save()

    Write-Host Page successfully added to site $web.Title! -ForegroundColor Green
}