<cfoutput>
#flashRender("user")#

<fieldset>

    <p>
        #textField(label="Fist Name", objectName="user", property="firstName", class="required text small", prepend="<br />")#
    </p>

    <p>
        #textField(label="Last Name", objectName="user", property="lastName", class="required text small", prepend="<br />")#
    </p>

    <p>
        #textField(label="Email", objectName="user", property="email", class="required text small", prepend="<br />")#
    </p>

    <p>
        #select(label="Time Zone", objectName="user", property="timezoneid", options=timezones, valueField="id", textField="name", includeBlank="false", prepend="<br />", class="styled wide")#
    </p>

    <p>
        #select(label="Date Format", objectName="user", property="dateformat", options=get('viewDateFormats'), valueField="format", textField="label", prepend="<br />", class="styled")#
    </p>


    <cfif ListFind("userAdd,userCreate,memberAdd,memberCreate", params.action)>
    <p>
        #passwordFieldTag(label="Password", name="password1", class="required text", value="", autocomplete="off", prepend="<br />")#
    </p>

    <p>
        #passwordFieldTag(label="Re-type Password", name="password2", class="required text", value="", autocomplete="off", prepend="<br />")#
    </p>
    <cfelse>
    <p>
        #passwordFieldTag(label="Change Password", name="password1", class="required text", value="", autocomplete="off", prepend="<br />")#
        #noteText("Please enter the password only if you want to change it.", "<br/>")#
    </p>

    <p>
        #passwordFieldTag(label="Re-type Password", name="password2", class="required text", value="", autocomplete="off", prepend="<br />")#
        #noteText("Please enter the password again to make sure it is spelled correctly.", "<br/>")#
    </p>
    </cfif>

    <cfif isAccountOwner() AND NOT ListFind("profile,profileUpdate", params.action)>
    <p>
        <label>User Role</label><br/>
        #radioButton(label=" Guest<br/>", objectName="user", property="accessLevel", tagValue="#get("accessLevelGuest")#", class="radio", labelPlacement="after")#
        #radioButton(label=" Author<br/>", objectName="user", property="accessLevel", tagValue="#get("accessLevelAuthor")#", class="radio", labelPlacement="after")#
        #radioButton(label=" Editor<br/>", objectName="user", property="accessLevel", tagValue="#get("accessLevelEditor")#", class="radio", labelPlacement="after")#
        #radioButton(label=" Developer<br/>", objectName="user", property="accessLevel", tagValue="#get("accessLevelDeveloper")#", class="radio", labelPlacement="after")#
        <cfif params.controller EQ "admin"  >
        <cfif isAdmin()>
            #radioButton(label=" Account Owner<br/>", objectName="user", property="accessLevel", tagValue="#get("accessLevelAccountOwner")#", class="radio", labelPlacement="after")#
        </cfif>                
        <cfif user.accountid EQ get("adminsAccountId")>            
            #radioButton(label=" Administrator<br/>", objectName="user", property="accessLevel", tagValue="#get("accessLevelAdmin")#", class="radio", labelPlacement="after")#
        </cfif>
        </cfif>
    </p>
    <p>
        #checkBox(label=" User is active", objectName="user", property="isActive", checkedValue="1", uncheckedValue="0", class="checkbox", labelPlacement="after")#
    </p>
    </cfif>

    <p>
        #submitTag(class="btn btn-primary btn-large", value=view.buttonLabel)#
    </p>

</fieldset>

<script type="text/javascript">
$(document).ready( function(){
    $(".required").requiredInput();
});
</script>
</cfoutput>