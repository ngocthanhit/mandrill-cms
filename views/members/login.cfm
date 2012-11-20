<cfoutput>
<div class="small center login">
	<div class="page-header">			
		<h2>#view.pageTitle#</h2>	
		#linkTo(text="Back to the website", href=get("metaWebsiteURL"), class="btn")#
	</div>
		  
	<div class="well">
		
		    #flashRender()#
		
		    #startFormTag(action="login")#
		        <p>
		            #textFieldTag(label="Email Address:", name="email", class="text", prepend="<br/>")#
		        </p>
		        <p>
		            #passwordFieldTag(label="Password:", name="password", class="text", prepend="<br/>")#
		        </p>
		        <p>
		            #submitTag(class="btn btn-primary btn-large", value="Login")#
		            #checkBoxTag(label=" Remember me on this computer", name="rememberme", class="checkbox", id="rememberme", labelPlacement="after")#
		        </p>
					
		        <p>
		            #linkTo(text="Forgot password?", controller="members", action="password")#
		            | #linkTo(text="Don't have an account? Register!", controller="members", action="signup")#
		        </p>
					
		    #endFormTag()#
		
	</div>
</div>
<script type="text/javascript">
$(document).ready( function(){
    $("input[name=email]").focus();
});
</script>
</cfoutput>