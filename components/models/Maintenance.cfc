<cfcomponent extends="models.Model" output="false" hint="Maintenance methods for misc models">



<cffunction name="archiveExpiredEvents" returntype="void" access="public" output="false" hint="Move expired syslog records into archive">
    <cfargument name="period" type="numeric" required="true" hint="Expiration period in days">
    <cfset var local = {} />
    <cftransaction>

        <cfquery datasource="#get('dataSourceName')#">
            insert into archivedevents (id, userid, action, type, message, detail, remoteIp, createdat)
            select id, userid, action, type, message, detail, remoteIp, createdat
            from currentevents
            where DATE_SUB(NOW(), interval <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#" /> DAY) > createdAt
        </cfquery>

        <cfquery datasource="#get('dataSourceName')#">
            delete from currentevents
            where DATE_SUB(NOW(), interval <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#" /> DAY) > createdAt
        </cfquery>

    </cftransaction>
</cffunction>



<cffunction name="archiveExpiredChanges" returntype="void" access="public" output="false" hint="Move expired changes history records into archive">
    <cfargument name="period" type="numeric" required="true" hint="Expiration period in days">
    <cfset var local = {} />
    <cftransaction>

        <cfquery datasource="#get('dataSourceName')#">
            insert into archivedchanges (id, userid, type, modelcode, modelid, packet, createdat)
            select id, userid, type, modelcode, modelid, packet, createdat
            from currentchanges
            where DATE_SUB(NOW(), interval <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#" /> DAY) > createdAt
        </cfquery>

        <cfquery datasource="#get('dataSourceName')#">
            delete from currentchanges
            where DATE_SUB(NOW(), interval <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#" /> DAY) > createdAt
        </cfquery>

    </cftransaction>
</cffunction>



<cffunction name="findExpiredAccounts" returntype="query" access="public" output="false" hint="Find all expired but still active accounts">
    <cfset var local = {} />

    <cfquery datasource="#get('dataSourceName')#" name="local.accounts">
        select id
        from accounts
        where expirationdate <= NOW() and status != 'expired'
    </cfquery>

    <cfreturn local.accounts />

</cffunction>



<cffunction name="findAllWithBilling" returntype="query" access="public" output="false" hint="Find all accounts with billing details">
    <cfargument name="status" type="string" required="false" default="" hint="Filter accounts by status">
    <cfargument name="order" type="string" required="false" default="name asc" hint="Ordering string">
    <cfset var local = {} />

    <cfquery datasource="#get('dataSourceName')#" name="local.accounts">
        select a.id, a.name as accountname, p.name as planname, d.discount, ap.price
        from accounts a
        inner join accountplans ap on ap.accountid = a.id
        inner join plans p on p.id = ap.planid
        inner join discounts d on d.id = ap.discountid
        where
            a.id != <cfqueryparam cfsqltype="cf_sql_integer" value="#get('visitorsAccountId')#" />
            and ap.isactive = <cfqueryparam cfsqltype="cf_sql_tinyint" value="1" />
            <cfif arguments.status NEQ "">and a.status = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.status#" /></cfif>
        order by a.#arguments.order#
    </cfquery>

    <cfreturn local.accounts />

</cffunction>



<cffunction name="findExpiredDiscounts" returntype="query" access="public" output="false" hint="Find all expired but still active discounts">
    <cfset var local = {} />

    <cfquery datasource="#get('dataSourceName')#" name="local.discounts">
        select id
        from discounts
        where expirationdate <= NOW() and isactive = 1
    </cfquery>

    <cfreturn local.discounts />

</cffunction>



</cfcomponent>