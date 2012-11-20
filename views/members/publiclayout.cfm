<cfoutput><!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Mandrill CMS</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">
		#styleSheetLinkTag("bootstrap,mandrillcms,bootstrap-responsive")#
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
		#javaScriptIncludeTag("jquery")#
    </head>
<body>

	<div class="container">

        <div class="wrapper">

			#includeContent()#

        </div>

	</div>

	#javaScriptIncludeTag("bootstrap")#

</body>
</html>
</cfoutput>