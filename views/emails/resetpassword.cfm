<cfoutput>
<p>Hello #HTMLEditFormat(maildata.firstname)#,</p>
<p>Someone used your email #HTMLEditFormat(maildata.email)# for MandrillCMS password resetting procedure.</p>
<p>If it was you, please click this link to proceed (or copy and paste in your browser):</p>
<p><a href="#maildata.baseURL#/members/password/?stamp=#urlEncodedFormat(maildata.stamp)#">#maildata.baseURL#/members/password/?stamp=#urlEncodedFormat(maildata.stamp)#</a></p>
<p>If you have not requested this email &ndash; ignore it, if this repeats &ndash; please contact us to research the issue.</p>
</cfoutput>