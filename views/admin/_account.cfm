<cfoutput>
#flashRender("account")#

<fieldset>

    <p>
        #textField(label="Account Name", objectName="account", property="name", class="required text small", prepend="<br />")#
    </p>

    <cfif isAdmin()>
    <p>
        #textField(label="Expires On", objectName="account", property="expirationDate", class="text date_picker", prepend="<br />")#
        #noteText("Set blank to have account never expired.")#
    </p>

    <p>
        #radioButton(label=" Account is Active<br/>", objectName="account", property="status", tagValue="active", class="radio", labelPlacement="after")#
        #radioButton(label=" Account is Locked<br/>", objectName="account", property="status", tagValue="locked", class="radio", labelPlacement="after")#
        #radioButton(label=" Account is Expired<br/>", objectName="account", property="status", tagValue="expired", class="radio", labelPlacement="after")#
    </p>
    <cfelse>
    <p>
        <label>Expires On</label> #HTMLEditFormat(account.expirationDate)#
    </p>
    </cfif>

    <cfif account.isNew()>
    <p>
        #select(label="Select Billing Plan", objectName="accountplan", property="planid", options=plans, valueField="id", textField="name", includeBlank="false", prepend="<br />", class="styled")#
    </p>
    <p>
        #select(label="Apply Discount", objectName="accountplan", property="discountid", options=discounts, valueField="id", textField="name", includeBlank="false", prepend="<br />", class="styled")#
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