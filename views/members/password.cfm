<cfoutput>
<div class="small center login">
    <div class="page-header">           
        <h2>#view.pageTitle#</h2>   
        #linkTo(text="Back to the website", href=get("metaWebsiteURL"), class="btn")#
    </div>

    <div class="well">

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
                #submitTag(class="submit", value="Confirm", class="btn btn-primary btn-large")#
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
                #submitTag(class="submit", value="Continue", class="btn btn-primary btn-large")#
            </p>
            <p>
                #linkTo(text="Return to login form.", action="login")#
            </p>
        </cfif>
        #endFormTag()#

    </div>
</div>
</cfoutput>