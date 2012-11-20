<cfoutput>
<p>
    Each action at this screen will produce account history record.<br/>
    TODO: update Recurly subscription on pricing change (queue API request).
</p>

#startFormTag(action="accountPlanUpdate", key=account.id)#
<fieldset>

    <p>
        #select(label="Select Plan", objectName="accountplan", property="planid", options=plans, valueField="id", textField="name", includeBlank="false", prepend="<br />", class="styled")#
        #noteText("New plan overrides current pricing and quotas.")#
    </p>

    <p>
        #submitTag(class="submit mid", value="Switch Plan")#
    </p>

</fieldset>
#endFormTag()#

#startFormTag(action="accountPlanUpdate", key=account.id)#
<fieldset>

    <p>
        #select(label="Select Discount", objectName="accountplan", property="discountid", options=discounts, valueField="id", textField="name", includeBlank="false", prepend="<br />", class="styled")#
        #noteText("New discount will be applied to current plan.")#
    </p>

    <p>
        #submitTag(class="submit mid", value="Apply Discount")#
    </p>

</fieldset>
#endFormTag()#

<script type="text/javascript">
$(document).ready( function(){
    $(".required").requiredInput();
});
</script>
</cfoutput>