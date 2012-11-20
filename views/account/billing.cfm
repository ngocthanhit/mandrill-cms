<cfoutput>
<h2>Current plan:</h2>

#includePartial("/account/currentplan")#

<h2>Current quotas:</h2>

#includePartial("/account/currentquotas")#

<p></p>


<h2>Available plans:</h2>

#includePartial("/account/planselect")#

<p></p>


<cfif accountplans.recordCount>
<h2>Previous plans:</h2>

<cfloop query="accountplans">
<div>
    <strong>&laquo;#HTMLEditFormat(accountplans.name)#&raquo;</strong>
    with price #DollarFormat(accountplans.price)#<cfif accountplans.discount> and discount #accountplans.discount#%</cfif>,
    was active since #formatDate(accountplans.createdAt)#
</div>
</cfloop>
</cfif>

<p></p>
#linkTo(text="DELETE ACCOUNT", action="delete", class="button mid-red")#

<p></p>
</cfoutput>