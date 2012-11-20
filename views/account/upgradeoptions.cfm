<cfoutput>
#flashRender(warnings=warnings)#

#startFormTag(action="upgrade", method="get")#

    #hiddenFieldTag(name="step", value="confirm")#

    <h2>Select new plan</h2>

    #includePartial("/account/planselect")#

    <h2>Discount coupon</h2>

    <p>
        #textFieldTag(name="coupon", value="#HTMLEditFormat(params.coupon)#", class="required text tiny")#
    </p>

    #submitTag(class="submit mid", value="Continue")#

#endFormTag()#

<p></p>
</cfoutput>