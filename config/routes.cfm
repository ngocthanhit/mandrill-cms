<!--- member default/langing page, visitors are redirected to login --->
<cfset addRoute(name="home", pattern="", controller="members", action="dashboard") />

<!--- lisitings with paging where key used --->
<cfset addRoute(name="adminAccountQuotasHistory", pattern="admin/account-quotas-history/[key]", controller="admin", action="accountQuotasHistory") />
<cfset addRoute(name="adminAccountUsers", pattern="admin/account-users/[key]", controller="admin", action="accountUsers") />
