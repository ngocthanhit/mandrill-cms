<cfoutput>
<div class="block small center login">

    <div class="block_head">
        <div class="bheadl"></div>
        <div class="bheadr"></div>

        <h2>#view.pageTitle#</h2>
        <ul>
            <li>#linkTo(text="Back to the website", href=get("metaWebsiteURL"))#</li>
        </ul>
    </div>


    <div class="block_content">

        #flashRender()#

        #startFormTag(action="login")#
            <p>
                #textFieldTag(label="Email Address:", name="email", class="text", prepend="<br/>")#
            </p>
            <p>
                #passwordFieldTag(label="Password:", name="password", class="text", prepend="<br/>")#
            </p>
            <p>
                #submitTag(class="submit", value="Login")#
                #checkBoxTag(label=" Remember me on this computer", name="rememberme", class="checkbox", id="rememberme", labelPlacement="after")#
            </p>
			<!---
            <p>
                #linkTo(text="Forgot password?", controller="members", action="password")#
                | #linkTo(text="Don't have an account? Register!", controller="members", action="signup")#
            </p>
			--->
        #endFormTag()#

    </div>

    <div class="bendl"></div>
    <div class="bendr"></div>

</div>

<script type="text/javascript">
$(document).ready( function(){
    $("input[name=email]").focus();
});
</script>
</cfoutput>