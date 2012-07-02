<cfoutput>
<div class="small center login">
    <div class="page-header">           
        <h2>#view.pageTitle#</h2>   
        #linkTo(text="Back to the website", href=get("metaWebsiteURL"), class="btn")#
    </div>

    <div class="well">

        #flashRender()#

        #startFormTag(action="signup")#
            <p>
                Please enter core information of your account.
            </p>
            <p>
                #textFieldTag(label="Account Name:", name="accountname", autocomplete="off", class="text", prepend="<br/>")#
            </p>
            <p>
                #textFieldTag(label="Email Address:", name="email1", autocomplete="off", class="text", prepend="<br/>")#
            </p>
            <p>
                #textFieldTag(label="Confirm Email:", name="email2", autocomplete="off", class="text", prepend="<br/>")#
            </p>
            <p>
                #passwordFieldTag(label="Password:", name="password1", autocomplete="off", class="text", prepend="<br/>")#
            </p>
            <p>
                #passwordFieldTag(label="Confirm Password:", name="password2", autocomplete="off", class="text", prepend="<br/>")#
            </p>
            <p>
                #submitTag(class="submit", value="Continue", class="btn btn-primary btn-large")#
            </p>
            <p>
                #linkTo(text="Already have an account? Please log in here.", controller="members", action="login")#
            </p>
        #endFormTag()#

    </div>
</div>
<script type="text/javascript">
$(document).ready( function(){
    $("input[name=accountname]").focus();
});
</script>
</cfoutput>