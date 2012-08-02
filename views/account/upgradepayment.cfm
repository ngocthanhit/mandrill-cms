<cfoutput>
#flashRender(warnings=warnings)#

#startFormTag(action="upgrade", method="get")#

    #hiddenFieldTag(name="step", value="completed")#
    #hiddenFieldTag(name="planid", value=params.planid)#
    #hiddenFieldTag(name="coupon", value=params.coupon)#

    <p>
        This page will display Recurly.js widget with payment options.
    </p>

    <p>
        On successful payment Recurly will send us webhook which will work as signal for upgrade completing.
    </p>

    <p>
        For now click Confirm for complete the upgrade process skipping the payment.
    </p>

    #submitTag(class="submit mid", value="Confirm")#

#endFormTag()#

<p></p>
</cfoutput>