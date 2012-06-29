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
                #submitTag(class="submit", value="Continue")#
            </p>
            <p>
                #linkTo(text="Already have an account? Please log in here.", controller="members", action="login")#
            </p>
        #endFormTag()#

    </div>

    <div class="bendl"></div>
    <div class="bendr"></div>

</div>

<script type="text/javascript">
$(document).ready( function(){
    $("input[name=accountname]").focus();
});
</script>
</cfoutput>