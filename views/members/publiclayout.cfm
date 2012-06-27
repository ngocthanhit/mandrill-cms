<cfoutput><!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Mandrill CMS</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">

        <link href="/#get('stylesheetPath')#/bootstrap.css" rel="stylesheet">
        <link href="/#get('stylesheetPath')#/mandrillcms.css" rel="stylesheet">
        <link href="/#get('stylesheetPath')#/bootstrap-responsive.css" rel="stylesheet">
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
		#javaScriptIncludeTag("jquery")#
    </head>
<body>

	<div class="container">

			#includeContent()#
		
	</div>
		
	#javaScriptIncludeTag("bootstrap")#
		
</body>
</html>
</cfoutput>