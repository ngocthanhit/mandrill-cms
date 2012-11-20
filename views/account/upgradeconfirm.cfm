<cfoutput>
#flashRender(warnings=warnings)#

#startFormTag(action="upgrade", method="get")#

    #hiddenFieldTag(name="step", value="payment")#
    #hiddenFieldTag(name="planid", value=params.planid)#
    #hiddenFieldTag(name="coupon", value=params.coupon)#

    <p>
        Please review all information carefully before proceeding.
    </p>

    <p>
        Selected billing plan is <strong>&laquo;#HTMLEditFormat(plan.name)#&raquo;</strong>
        with monthly <strong>price</strong> of <strong>#DollarFormat(plan.price)#</strong>.<br/>
    <cfif isObject(discount)>
        To account applied <strong>discount</strong> &laquo;#HTMLEditFormat(discount.name)#&raquo;
        of <strong>#discount.discount#%</strong>.<br/>
    </cfif>
        Next renew date is #formatDate(DateAdd('m', 1, Now()))#.
    </p>

    <p>
        On next step you will be presented with payment screen.
    </p>

    #linkTo(text="&larr; Back", action="upgrade", class="button mid", params="planid=#params.planid#&coupon=#params.coupon#")#
    #submitTag(class="submit mid", value="Continue")#

#endFormTag()#

<p></p>
</cfoutput>