<cfoutput>
<cfloop query="features">
    <div class="floating-label mid" title="#HTMLEditFormat(features.description)#">#HTMLEditFormat(features.name)#:</div>
    <cfif features.token EQ "Hosting">
    	#quotaHostingValue(quotasCacheAccount[features.id].current)#
    <cfelse>
    #HTMLEditFormat(quotasCacheAccount[features.id].current)# of #HTMLEditFormat(quotasCacheAccount[features.id].quota)# #HTMLEditFormat(features.unit)#
    </cfif>
    <br/>
</cfloop>
</cfoutput>