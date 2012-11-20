<cfoutput>
#startFormTag(action="planQuotasUpdate", key=params.key)#
<fieldset>

    <cfloop query="features">
        <p>
            <label for="features-#features.id#">#HTMLEditFormat(features.name)#<cfif features.unit NEQ "">, #features.unit#</cfif></label><br/>
            <cfif features.token EQ "Hosting">
                <select id="features-#features.id#" name="quotas[#features.id#]">
                    <option value="1"<cfif StructKeyExists(quotasCache, features.id) and StructFind(quotasCache, features.id) eq 1> selected="selected"</cfif>>No</option>
                    <option value="2"<cfif StructKeyExists(quotasCache, features.id) and StructFind(quotasCache, features.id) eq 2> selected="selected"</cfif>>Yes</option>
                </select>
            <cfelse>
                <cfif StructKeyExists(quotasCache, features.id)>
                <input type="text" id="features-#features.id#" name="quotas[#features.id#]" value="#HTMLEditFormat(quotasCache[features.id])#" class="required text tiny" />
                <cfelse>
                <input type="text" id="features-#features.id#" name="quotas[#features.id#]" value="" class="required text tiny" />
                </cfif>
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