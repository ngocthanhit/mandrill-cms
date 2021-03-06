<!--- member default/langing page, visitors are redirected to login --->
<cfset addRoute(name="home", pattern="", controller="members", action="dashboard") />
<!--- password reset confirmation link --->
<cfset addRoute(name="passwordConfirm", pattern="members/password/[stamp]", controller="members", action="password") />
<!--- lisitings with paging where key used --->
<cfset addRoute(name="adminAccountQuotasHistory", pattern="admin/account-quotas-history/[key]", controller="admin", action="accountQuotasHistory") />
<cfset addRoute(name="adminAccountUsers", pattern="admin/account-users/[key]", controller="admin", action="accountUsers") />
