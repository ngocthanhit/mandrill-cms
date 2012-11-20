<cfoutput>
<p>Hey there,</p>
<p>I'm sorry to say this, but one of our clients decided to delete their account. See details below.</p>
<p>Account was <strong>#HTMLEditFormat(maildata.name)#</strong></p>
<p>Deleted by <strong>#HTMLEditFormat(maildata.email)#</strong></p>
<p>Comments:<br/>#HTMLEditFormat(maildata.comments)#</p>
</cfoutput>