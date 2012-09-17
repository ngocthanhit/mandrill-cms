<cfoutput>
<html>
    <head>
        <title>Preview - #Params.Newpages.title#</title>
    </head>
    <body>
        <strong>Main Content</strong> : #Params.Newpages.content#
        <button onClick="window.close();window.opener.focus();">Close Preview</button>
    </body>
</html>
</cfoutput>
<cfabort>