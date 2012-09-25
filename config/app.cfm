<cfscript>
    this.name = "MandrillCMS";
    this.sessionmanagement = true;
    this.sessiontimeout = CreateTimeSpan(0,0,60,0);
    this.applicationtimeout = CreateTimeSpan(0,12,0,0);
    this.scriptProtect = "none";
</cfscript>