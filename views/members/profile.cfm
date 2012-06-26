<cfoutput>
<p>
	If you see this text and URL looks like <strong>http://#cgi.SERVER_NAME#/members/profile</strong> -- rewriting works!
</p>
#get("hashingKey")#<br />
#Hash("Visitor" & get("hashingKey"), "SHA-256")#<br />
#Hash("David" & get("hashingKey"), "SHA-256")#<br />	
#Hash("Sergey" & get("hashingKey"), "SHA-256")#<br />
#Hash("Alex" & get("hashingKey"), "SHA-256")#<br />
#Hash("Maimun" & get("hashingKey"), "SHA-256")#
</cfoutput>