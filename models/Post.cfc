
<cfcomponent output="false" extends="model">

	<cffunction name="init">
		<!--- Post belongs to user, association between users and posts table 'foreignkey= userid' --->
    	<cfset belongsTo(name="user",foreignkey="userid")>
		<!--- Post status has statusid, that's associated with Statuses table --->		
		<cfset belongsTo(name="status",foreignkey="statusid")>
		
		<cfset hasMany(name='postcategorymapping', modelname="postcategorymapping", foreignkey="userid")>
		
		<!--- To make form/ table fields required --->
    	<cfset validatesPresenceOf("content, title, description")>
		<!--- title field is unique for the table 'Pages'--->
       <cfset validatesUniquenessOf("title")> 
	   
	   <cfset validate(method="checkCategory")> 
	   
	</cffunction>
	
	<cffunction name="checkCategory">
		<cfif not IsDefined("form.categoryID")>
			<cfset adderror(property="categoryid",message="Category field is required.") >	
		</cfif>		
	</cffunction>
	
</cfcomponent>
