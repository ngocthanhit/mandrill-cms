<cfoutput>
<div class="navbar">
    <div class="navbar-inner">
        <div class="container">
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>
            <a class="brand" href="">Mandrill CMS</a>
            <div class="nav-collapse">
                <ul class="nav">
                    <li <cfif params.controller eq "Members">class="active"</cfif>>#linkTo(text='Dashboard', route="home")#</li>
                     <li <cfif params.controller eq "Pages">class="active"</cfif>>#linkTo(text='Pages', controller='Pages')#</li>
                     <li <cfif params.controller eq "Posts">class="active"</cfif>>#linkTo(text='Posts', controller='Posts')#</li>
                    <li <cfif params.controller eq "Webfiles">class="active"</cfif>>#linkTo(text='Files', controller='Webfiles')#</li>
                    <cfset sites = model("site").findALL(where="accountid=#getAccountAttr('id')# AND userid=#getUserAttr('id')#") >
                    <li class="dropdown<cfif params.controller eq "websites"> active</cfif>">
                        <a href="##" class="dropdown-toggle" data-toggle="dropdown">
                            Sites
                            <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li>#linkTo(text='Site Settings', controller='Websites')#</li>
                            <cfif sites.recordcount GT 0>
                            <li class="divider"></li>
                             <li class="nav-header">SITES</li>
                                <cfloop query="sites">
                                    <li>#linkTo(text='#sites.URL# ', controller='Websites',action="setChooseSite",params="siteid=#sites.id#")#</li>
                                </cfloop>
                            </cfif>
                        </ul>
                    </li>
                    <li><a href="">Marketing</a></li>
                    <li class="dropdown">
                        <a href="##" class="dropdown-toggle" data-toggle="dropdown">
                            Settings
                            <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li>#linkTo(text="Your Profile", controller="members", action="profile")#</li>
                            <cfif isAccountOwner()>
                            <li class="divider"></li>
                            <li class="nav-header">YOUR ACCOUNT</li>
                            <li>#linkTo(text="Team Members", controller="account", action="members")#</li>
                            <li>#linkTo(text="Billing &amp; Plans", controller="account", action="billing")#</li>
                            </cfif>
                            <cfif isAdmin()>
                            <li class="divider"></li>
                            <li class="nav-header">ADMINISTRATOR</li>
                            <li>#linkTo(text="Accounts &amp; Users", controller="admin", action="accounts")#</li>
                            <li>#linkTo(text="Billing Settings", controller="admin", action="billing")#</li>
                            <li>#linkTo(text="System Log", controller="admin", action="syslog")#</li>
                            <li>#linkTo(text="Data History", controller="admin", action="history")#</li>
                            </cfif>
                            <!---
                            <cfif isDeveloper()>
                            <li class="divider"></li>
                            <li class="nav-header">DEVELOPER</li>
                            <li>#linkTo(text="Sandbox", controller="admin", action="sandbox")#</li>
                            </cfif>
                            --->
                        </ul>
                    </li>
                    <li>#linkTo(text='Logout', controller='members', action='logout')#</li>
                </ul>
                <cfif issiteid()>
                <cfquery dbtype="query" name="getSite">
                    SELECT * FROM SITES WHERE  id = '#getsiteid()#'
                </cfquery>
                <div class="span3">
                #getSite.name#<br />
                #getSite.URL#</div>
                </cfif>
                <p class="user">Logged in as #getUserAttr("firstName")# #getUserAttr("lastName")#</p>
            </div>
        </div>
    </div>
</div>
</cfoutput>
