<cfcomponent extends="models.Model" output="false" hint="Custom data processing methods for User model">


<cffunction name="findAllPermissions" returntype="query" access="public" output="false" hint="Fetch all possible permissions with user defaults">
    <cfargument name="granted" type="numeric" required="true" hint="Default status for granted flag (depends on security mode)">
    <cfargument name="userid" type="numeric" required="false" default="0" hint="Override current user id">
    <cfset var local = {} />

    <!--- override object key with argument or try to use current value --->
    <cfset local.userid = arguments.userid ? arguments.userid : (this.isNew() ? 0 : this.id) />

    <!--- get all tokens with available values, undefined are populated with default --->
    <cfquery datasource="#get('dataSourceName')#" name="local.permissions">
        select pt.id, ifnull(pv.granted, <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.granted#" />) as granted
        from permissiontokens pt
        left outer join permissionvalues pv
            on pt.id = pv.permissiontokenid
            and pv.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userid#" />
        order by pt.id asc
    </cfquery>

    <cfreturn local.permissions />

</cffunction>


</cfcomponent>