<cfoutput>
<html>
    <head>
        <title>Preview - #Params.newPost.title#</title>
    </head>
    <body>
        <strong>Main Content</strong> : #Params.newPost.content#
        <button onClick="window.close();window.opener.focus();">Close Preview</button>
    </body>
</html>
</cfoutput>
<cfabort>