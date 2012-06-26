<cfscript>
try {

    // log session ending to file
    _text("information", "Session ended: #session.sessionid#", "sessions");

    // log logout by timeout
    if (StructKeyExists(session, "accountid") AND StructKeyExists(session, "userid") AND session.userid GT 1) {

        // push event using query because wheels is not fully available

        var qry = new query();

        qry.setDatasource(application.wheels.dataSourceName);

        qry.addParam(cfsqltype="cf_sql_integer", value=session.accountid);
        qry.addParam(cfsqltype="cf_sql_integer", value=session.userid);
        qry.addParam(cfsqltype="cf_sql_char", value="page.home");
        qry.addParam(cfsqltype="cf_sql_char", value="Members");
        qry.addParam(cfsqltype="cf_sql_char", value="Automatically logged out due to inactivity");
        qry.addParam(cfsqltype="cf_sql_char", value=cgi.REMOTE_ADDR);

        qry.setSql("insert into currentevents (accountid, userid, action, category, message, remoteIp, createdAt) values (?, ?, ?, ?, ?, ?, NOW())");

        qry.execute();

    }

}
catch (any exception) {
    _text("error", exception.message, "sessions");
}
</cfscript>