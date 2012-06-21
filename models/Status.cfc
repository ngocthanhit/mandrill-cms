
<cfcomponent output="false" extends="model">
	<cffunction name="init">
    	<!---pages table associated with statuses table on statusid (draft, published) --->
		<cfset hasOne(name='status', modelname="page", foreignkey="statusid")>
		<!---posts table associated with statuses table on statusid (draft, published) --->
		<cfset hasOne(name='status', modelname="post", foreignkey="statusid")>
	</cffunction>
</cfcomponent>