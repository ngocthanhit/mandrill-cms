
<cfcomponent output="false" extends="model">
	<cffunction name="init">
		<cfset belongsTo(name="category",foreignkey="categoryid")>
		<cfset belongsTo(name="post",foreignkey="postid")>
	</cffunction>
</cfcomponent>