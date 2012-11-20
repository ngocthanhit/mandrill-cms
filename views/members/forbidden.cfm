<cfoutput>
<p>Sorry, but you are not authorized to access this page. Please try one of these options...</p>
<ul>
    <cfif isLoggedIn()>
    <li>#linkTo(text="Return to the dashboard", route="home")#</li>
    <li>#linkTo(text="Log out and authenticate as different user", controller="members", action="logout")#</li>
<!---
    <cfelseif params.action NEQ "login">
    <li>#linkTo(text="Log in as registered user", controller="members", action="login", params="r=#URLEncodedFormat('/#LCase(params.controller)#/#params.action#/?#cgi.QUERY_STRING#')#")#</li>
 --->
    <cfelse>
    <li>#linkTo(text="Log in as registered user", controller="members", action="login")#</li>
    </cfif>
    <li>#linkTo(text="Return to the site", route="home")#</li>
</ul>
</cfoutput>