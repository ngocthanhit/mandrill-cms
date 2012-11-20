<cfoutput>
<table cellpadding="0" cellspacing="0" class="sortable">

<tr>
    <td>&nbsp;</td>
    <cfloop query="plans">
    <th style="width:150px; text-align:center;" title="#HTMLEditFormat(plans.description)#">
        #HTMLEditFormat(plans.name)#
    </th>
    </cfloop>
</tr>

<cfloop query="features">
<tr>
    <th>#HTMLEditFormat(features.name)#</th>
    <cfloop query="plans">
    <td style="text-align:center;">
        <cfif features.token EQ "Hosting">
        #quotaHostingValue(quotasCachePlan[features.id][plans.id])#
        <cfelse>
        #HTMLEditFormat(quotasCachePlan[features.id][plans.id])# #HTMLEditFormat(features.unit)#
        </cfif>
    </td>
    </cfloop>
</tr>
</cfloop>

<tr>
    <th>Price/month</th>
    <cfloop query="plans">
    <th style="text-align:center;">
        #DollarFormat(plans.price)#
    </td>
    </cfloop>
</tr>

<cfif params.action EQ "upgrade">
<tr>
    <td>&nbsp;</td>
    <cfloop query="plans">
    <td style="text-align:center;">
        <cfif plans.id EQ accountplan.planid>
        [current]
        <cfelse>
        #radioButtonTag(name="planid", value=plans.id, checked=(params.planid EQ plans.id))#
        </cfif>
    </td>
    </cfloop>
</tr>
<cfelse>
<tr>
    <th>&nbsp;</th>
    <cfloop query="plans">
    <td style="text-align:center;">
        <cfif plans.id EQ accountplan.planid>
        [current]
        <cfelseif plans.price LT accountplan.plan.price>
        #linkTo(text="Downgrade", action="upgrade", class="button mid", params="planid=#plans.id#")#
        <cfelse>
        #linkTo(text="Upgrade", action="upgrade", class="button mid", params="planid=#plans.id#")#
        </cfif>
    </td>
    </cfloop>
</tr>
</cfif>

</table>
</cfoutput>