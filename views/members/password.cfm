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

        <cfif params.phase EQ "passwords">
        #startFormTag(route="passwordConfirm", stamp=params.stamp)#
            <p>
                Please enter new password to set for your account.
            </p>
            <p>
                #passwordFieldTag(label="New Password:", name="password1", class="text", prepend="<br/>")#
            </p>
            <p>
                #passwordFieldTag(label="Re-type New Password:", name="password2", class="text", prepend="<br/>")#
            </p>
            <p>
                #submitTag(class="submit", value="Confirm")#
            </p>
            <p>
                #linkTo(text="&larr; Back to login form", action="login")#
            </p>
        <cfelse>
        #startFormTag(action="password")#
            <p>
                Please enter email address to start the password reset process.<br/>
                Forgot email address? Please #linkTo(text="contact support", href=get("metaWebsiteURL"))#.
            </p>
            <p>
                #textFieldTag(label="Email Address:", name="email", class="text", prepend="<br/>")#
            </p>
            <p>
                #submitTag(class="submit", value="Continue")#
            </p>
            <p>
                #linkTo(text="Return to login form.", action="login")#
            </p>
        </cfif>
        #endFormTag()#

    </div>

    <div class="bendl"></div>
    <div class="bendr"></div>

</div>
</cfoutput>