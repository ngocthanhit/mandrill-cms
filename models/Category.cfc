
<cfcomponent output="false" extends="model">
	<cffunction name="init">
		<cfset hasMany(name='postcategorymapping', modelname="postcategorymapping", foreignkey="categoryid")>
	</cffunction>
</cfcomponent>