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
                    <li><a href="">Pages</a></li>
                    <li><a href="">Posts</a></li>
                    <li><a href="">Files</a></li>
                    <li><a href="">Marketing</a></li>
                    <li><a href="">Users</a></li>
                    <li><a href="">Settings</a></li>
					<li>
			            #linkTo(text="Logout", controller="members", action="logout")#
			        </li>
                </ul>
				
				<p class="user">Logged in as #getUserAttr("firstName")# #getUserAttr("lastName")#</p>
        	
			</div>
    	</div>
	</div>
</div>
</cfoutput>