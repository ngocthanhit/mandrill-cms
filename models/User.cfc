
<cfcomponent output="false" extends="model">
	<cffunction name="init">
		<!---users table has association with pages, a userid can be associated with more than one pages --->
    	<cfset hasMany(name='pageof', modelname="pages", foreignkey="userid")>
		<!---users table has association with posts, a userid can be associated with more than one posts --->
		<cfset hasMany(name='postof', modelname="posts", foreignkey="userid")>
		
      	<cfset validatesPresenceOf("fname, lname, uname, email, password")>
        <cfset validatesFormatOf(property="email", type="email")>
        <cfset validatesLengthOf(property="fname", maximum=24)>
        <cfset validatesLengthOf(property="lname", maximum=48)>
        <cfset validatesLengthOf(property="password", maximum=48)>
        <cfset validatesConfirmationOf("password")>
		<cfset validatesUniquenessOf("email, uname")> 
		
	</cffunction>
</cfcomponent>