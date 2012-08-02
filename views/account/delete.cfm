<cfoutput>
#startFormTag(action="delete", params="confirm=yes")#
<fieldset>

    <p>
        <strong>IMPORTANT:</strong> when you click on the 'Delete Account' button below, your account and all its data will be deleted permanently.
    </p>
    <p>
        If you have credit on your account, please #linkTo(text="contact support", href=get("metaWebsiteURL"), class="external", target="_blank")# before you delete your account to request a refund.
    </p>
    <p>
        Mind leaving a goodbye message and telling us why you are unsubscribing?<br/>
        #textAreaTag(name="comments", class="small")#
    </p>
    <p>
        <strong>You are permanently deleting your account and all its data, and cancelling your MandrillCMS subscription - are you sure?</strong>
    </p>
    <p>
        #submitTag(class="submit mid", value="Delete Account")#
        #linkTo(text="I've changed my mind, take me back to billing", action="billing")#
    </p>
</fieldset>
#endFormTag()#
</cfoutput>