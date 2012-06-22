<cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>#HTMLEditFormat(view.pageTitle)# - MandrillCMS</title>
    <link media="screen" rel="stylesheet" type="text/css" href="/#get('stylesheetPath')#/screen.css" />
	<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=7" /><![endif]-->
	<!--[if lt IE 8]><style type="text/css" media="all">@import url("/#get('stylesheetPath')#/ie.css");</style><![endif]-->
	<!--[if IE]><script type="text/javascript" src="/#get('javascriptPath')#/excanvas.js"></script><![endif]-->
    #javaScriptIncludeTag("jquery,jquery.img.preload,jquery.select_skin,jquery.pngfix,layout,contactchimp")#
</head>
<body>

	<div id="hld">

		<div class="wrapper">

#includeContent()#

		</div>

	</div>

</body>
</html>
</cfoutput>