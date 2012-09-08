<cfset sites = model("site").findALL(where="accountid=#getAccountAttr('id')# AND userid=#getUserAttr('id')#") >
<cfoutput>
  <header>
  <div class="navbar navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container-fluid">
             <cfif issiteid()>
                <cfquery dbtype="query" name="getSite">
                    SELECT * FROM SITES WHERE  id = '#getsiteid()#'
                </cfquery>
                 <a class="brand pull-left" href="/"><small>#getSite.name#</small><br /><strong>#getSite.URL#</strong></a>
              <cfelse>
              <a class="brand pull-left" href="/"><small>COMPANY NAME</small><br /><strong>COMPANY-WEBSITE.CO.UK</strong></a>
         </cfif>
        <div class="nav-collapse">
          <ul class="nav mainnav">
            <li <cfif params.controller eq "Members">class="active"</cfif>>#linkTo(text='Dashboard', route="home")#</li>
            <li class="dropdown<cfif params.controller eq 'websites'> active</cfif>">
              <a href="##" class="dropdown-toggle" data-toggle="dropdown">Sites <b class="caret"></b></a>
              <ul class="dropdown-menu" id="sites_menu">
                <li>#linkTo(text='Site Settings', controller='Websites')#</li>
                <li><a href="##">Templates</a></li>
                <li><a href="##">Integrations</a></li>
                <cfif sites.recordcount GT 0>
                    <li class="divider"></li>
                    <li class="nav-header">SITES</li>
                    <cfloop query="sites">
                        <li>#linkTo(text='#sites.URL# ', controller='Websites',action="setChooseSite",params="siteid=#sites.id#")#</li>
                    </cfloop>
                </cfif>
              </ul>
            </li>
            <li class="dropdown">
              <a href="##" class="dropdown-toggle" data-toggle="dropdown">Content <b class="caret"></b></a>
              <ul class="dropdown-menu" id="content_menu">
                <li>#linkTo(text='Pages', controller='Pages')#</li>
                <li>#linkTo(text='Posts', controller='Posts')#</li>
                <li><a href="##"> Forms</a></li>
                <li>#linkTo(text='Files', controller='Webfiles')#</li>
              </ul>
            </li>
            <li class="dropdown">
              <a href="##" class="dropdown-toggle" data-toggle="dropdown">Marketing <b class="caret"></b></a>
              <ul class="dropdown-menu" id="marketing_menu">
                <li><a href="##">Analytics </a></li>
                <li><a href="##">A/B Testing </a></li>
              </ul>
            </li>
            <li class="dropdown">
              <a href="##" class="dropdown-toggle" data-toggle="dropdown">Help <b class="caret"></b></a>
              <ul class="dropdown-menu" id="help_menu">
                <li><a href="##">Documentation </a></li>
                <li><a href="##">Support </a></li>
              </ul>
            </li>
          </ul>
          <ul class="nav pull-right second-nav">
            <li class="dropdown settings">
              <a href="##" class="dropdown-toggle" data-toggle="dropdown">#getUserAttr("firstName")# #getUserAttr("lastName")#  <b class="caret"></b></a>
              <ul class="dropdown-menu" id="account_menu">
                <li>#linkTo(text="Your Profile", controller="members", action="profile")#</li>
                <cfif isAccountOwner()>
                    <li class="divider"></li>
                    <li class="nav-header">Your Account</li>
                    <li><a href="##">Account overview</a></li>
                    <li>#linkTo(text="Team Members", controller="account", action="members")#</li>
                    <li>#linkTo(text="Billing &amp; Plans", controller="account", action="billing")#</li>
                    <li><a href="##">Payments History </a></li>
                </cfif>
                <cfif isAdmin()>
                    <li class="divider"></li>
                    <li class="nav-header">Administrator</li>
                    <li>#linkTo(text="Accounts &amp; Users", controller="admin", action="accounts")#</li>
                    <li>#linkTo(text="Billing Settings", controller="admin", action="billing")#</li>
                    <li>#linkTo(text="System Log", controller="admin", action="syslog")#</li>
                    <li>#linkTo(text="Data History", controller="admin", action="history")#</li>
                </cfif>
              </ul>
            </li>
            <li class="logout">#linkTo(text='Logout', controller='members', action='logout')#</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  </header>
</cfoutput>