<cfoutput>
#flashRender("feature")#

#startFormTag(action="featureUpdate", key=params.key)#
<fieldset>

    <p>
        #textField(label="Feature Name", objectName="feature", property="name", class="required text small", prepend="<br />")#
        #noteText("Name should be short enough to fit the client's GUI", "<br/>")#
    </p>

    <p>
        #textField(label="Position", objectName="feature", property="position", class="required text nano", prepend="<br />")#
        #noteText("Features are sorted by position when displayed for client", "<br/>")#
    </p>

    <p>
        #textArea(label="Description", objectName="feature", property="description", class="small", prepend="<br />")#
    </p>

    <p>
        #checkBox(label=" Feature is Active", objectName="feature", property="isactive", checkedValue="1", uncheckedValue="0", class="checkbox", labelPlacement="after")#
        #noteText("Inactive feature is not visible for clients and corresponding quota is not checked", "<br/>")#
    </p>

    <p>
        #submitTag(class="submit mid", value="Save Feature")#
    </p>

</fieldset>
#endFormTag()#

<script type="text/javascript">
$(document).ready( function(){
    $(".required").requiredInput();
});
</script>
</cfoutput>