<cfoutput>
#flashRender("plan")#

<fieldset>

    <p>
        #textField(label="Plan Name", objectName="plan", property="name", class="required text small", prepend="<br />")#
        #noteText("Name should be short enough to fit the client's GUI.", "<br/>")#
    </p>

    <p>
        #textField(label="Default Price", objectName="plan", property="price", class="required text nano", prepend="<br />")#
        #noteText("Value used as initial value for account plan price.", "<br/>")#
    </p>

    <p>
        #textField(label="Position", objectName="plan", property="position", class="required text nano", prepend="<br />")#
        #noteText("Plans are sorted by position when displayed.", "<br/>")#
    </p>

    <p>
        #textArea(label="Description", objectName="plan", property="description", class="small", prepend="<br />")#
    </p>

    <p>
        #checkBox(label=" Plan is Active", objectName="plan", property="isactive", checkedValue="1", uncheckedValue="0", class="checkbox", labelPlacement="after")#
        #noteText("Inactive plan cannot be used anywhere.", "<br/>")#
        #noteText("<strong>Important:</strong> when plan is deactivated all accounts with it are forced to upgrade on next login.", "<br/>")#
    </p>

    <p>
        #checkBox(label=" Plan is Public", objectName="plan", property="ispublic", checkedValue="1", uncheckedValue="0", class="checkbox", labelPlacement="after")#
        #noteText("Public plans can be selected for signup and upgrade.", "<br/>")#
    </p>

    <p>
        #submitTag(class="submit mid", value=view.buttonLabel)#
        <cfif NOT plan.isNew() AND NOT plan.isUsed()>
        #linkTo(text="Delete Plan", action="planDelete", key=params.key, class="button mid-red", confirm="Are you sure you want to delete this plan completely?")#
        </cfif>
        #noteText("It is possible to delete only plans which never have been used.", "<br/>")#
    </p>

</fieldset>

<script type="text/javascript">
$(document).ready( function(){
    $(".required").requiredInput();
});
</script>
</cfoutput>