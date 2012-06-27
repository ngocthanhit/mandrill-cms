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
					<li class="active">#linkTo(text='Dashboard', route="home")#</li>
				 	<li>#linkTo(text='Pages', controller='Pages')#</li>
				 	<li>#linkTo(text='Posts', controller='Posts')#</li>
					<li><a href="">Files</a></li>
					<li><a href="">Marketing</a></li>
				    <li class="dropdown">
				    	<a href="##" class="dropdown-toggle" data-toggle="dropdown">
				    		Settings
							<b class="caret"></b>
						</a>
						<ul class="dropdown-menu">
							<li><a href="">Personal Profile</a></li></li>
							
							<cfif isAccountOwner()>
							<li class="divider"></li>
			                <li class="nav-header">YOUR ACCOUNT</li>
			                <li>#linkTo(text="Team Members", controller="account", action="members")#</li>
			                </cfif>
			                <cfif isAdmin()>
							<li class="divider"></li>
			                <li class="nav-header">ADMINISTRATOR</li>
			                <li>#linkTo(text="Accounts &amp; Users", controller="admin", action="accounts")#</li>
			                <li><a href="">System Log</a></li>
			                <li><a href="">Data History</a></li>
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
								
				<p class="user">Logged in as #getUserAttr("firstName")# #getUserAttr("lastName")#</p>
													        	
			</div>
		</div>
	</div>
</div>	
</cfoutput>