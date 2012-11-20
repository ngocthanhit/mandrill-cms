<cfoutput>
#startFormTag(action="accountQuotasUpdate", key=params.key)#
<fieldset>

    <cfloop query="features">
    <p>
        <label for="quotas-#quotasCache[features.id].id#">#HTMLEditFormat(features.name)#<cfif features.unit NEQ "">, #features.unit#</cfif></label><br/>
        <cfif features.token EQ "Hosting">
        <select id="quotas-#quotasCache[features.id].id#" name="quotas[#quotasCache[features.id].id#]">
            <option value="1"<cfif quotasCache[features.id].quota eq 1> selected="selected"</cfif>>No</option>
            <option value="2"<cfif quotasCache[features.id].quota eq 2> selected="selected"</cfif>>Yes</option>
        </select>
        <cfelse>
        <input type="text" id="quotas-#quotasCache[features.id].id#" name="quotas[#quotasCache[features.id].id#]" value="#HTMLEditFormat(quotasCache[features.id].quota)#" class="required text tiny" />
        </cfif>
    </p>
    </cfloop>

    <p>
        #submitTag(class="submit mid", value="Save Quotas")#
        <span>Note: quota value must be positive ordinal number, invalid values are silently skipped.</span>
    </p>

</fieldset>
#endFormTag()#

<script type="text/javascript">
$(document).ready( function(){
    $(".required").requiredInput();
});
</script>
</cfoutput>