<cfoutput>
<p>
    Current billing plan is <strong>&laquo;#HTMLEditFormat(accountplan.plan.name)#&raquo;</strong>
    with monthly <strong>price</strong> of <strong>#DollarFormat(accountplan.price)#</strong>.<br/>
<cfif accountplan.discount.id NEQ get("defaultDiscountId")>
    To account applied <strong>discount</strong> &laquo;#HTMLEditFormat(accountplan.discount.name)#&raquo;
    of <strong>#accountplan.discount.discount#%</strong>.<br/>
</cfif>
    Plan is active since #formatDate(accountplan.createdAt)#.<br/>
<cfif accountplan.plan.id NEQ get("defaultPlanId")>
    Next renew date is #formatDate(DateAdd('m', 1, accountplan.renewedAt))#.
</cfif>
</p>
</cfoutput>