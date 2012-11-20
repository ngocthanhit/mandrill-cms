<cfcomponent extends="models.Model" output="false" hint="Custom data processing methods for Accountquota model">



<cffunction name="findQuotaByFeatureToken" returntype="any" access="public" output="false" hint="Get active account quota model by feature token and account id">
    <cfargument name="token" type="string" required="true" hint="Target feature token" />
    <cfargument name="accountid" type="numeric" required="true" hint="Target account id" />
    <cfset var local = {} />

    <cfquery datasource="#get('dataSourceName')#" name="local.getQuota">
        select ac.id
        from accountquotas ac
        inner join quotas q on ac.quotaid = q.id
        inner join features f on q.featureid = f.id
        where
            ac.accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountid#" />
            and f.token = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.token#" />
            and ac.isactive = <cfqueryparam cfsqltype="cf_sql_tinyint" value="1" />
        limit 1
    </cfquery>

    <cfif local.getQuota.recordCount>
        <cfreturn model("accountquota").findByKey(local.getQuota.id) />
    <cfelse>
        <cfreturn false />
    </cfif>

</cffunction>



</cfcomponent>