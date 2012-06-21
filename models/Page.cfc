
<cfcomponent output="false" extends="model">
	<cffunction name="init">
		<!--- Page belongs to user, association between users and pages table 'foreignkey= userid' --->
    	<cfset belongsTo(name="user",foreignkey="userid")>
		<!--- Page status has statusid, that's associated with Statuses table --->		
		<cfset belongsTo(name="status",foreignkey="statusid")>
		<!--- To make form/ table fields required --->
    	<cfset validatesPresenceOf("content, title, description")>
		<!--- title field is unique for the table 'Pages'--->
       <cfset validatesUniquenessOf("title")> 
	   <!--- some conditional or miscellaneous validation  --->
	    <cfset validate(method="checkPasswordFields")> 
		
	</cffunction>
	
	<cffunction name="checkPasswordFields" hint="this validates password field 'required', if isprotected or issubpageprotected is checked.">
			<cfif (this.isprotected is 1 OR this.issubpageprotected is 1) AND this.password eq ""> 
					<cfset adderror(property="password",message="Password field is required, if you want to protect page or sub-pages.") >		 
			</cfif>
	</cffunction>
</cfcomponent>
