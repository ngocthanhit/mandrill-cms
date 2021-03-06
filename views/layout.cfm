<cfoutput><!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Mandrill CMS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
	#styleSheetLinkTag('bootstrap,style,mandrillcms,jquery.ui,bootstrap-responsive,bootstrap-wysihtml5')#
    <!--[if lt IE 9]>
        <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <script src="//feather.aviary.com/js/feather.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    <!--- jquery --->
    #javaScriptIncludeTag("jquery.ui,layout,mandrillcms,lib/js/wysihtml5-0.3.0,src/bootstrap-wysihtml5")#
    #javaScriptIncludeTag("bootstrap,jquery.dialog2")#
  </head>
<body>
<div class="wrap-conteiner">
 <div class="container-fluid">

    <div class="modal hide" id="myModal" style="z-index:10001;">
       <div class="modal-body">
        <p align="center">#imageTag("ajax-loader.gif")# Loading...</p>
       </div>
    </div>

  <cfif isLoggedIn()>#includePartial("/shared/navigation")#</cfif>

  <div class="content">
    <div class="row-fluid">
      <article>
          <div class="row-fluid headering">
            <h1 class="pull-left">#view.pageTitle#<cfif view.pageTitleAppend NEQ ""> #view.pageTitleAppend#</cfif></h1>
          </div>
          <div class="contentarea">
            <cfif view.renderFlash>#flashRender()#</cfif>
            #includeContent()#
          </div>
      </article>
    </div>
  </div>

  </div>
</div>

  <footer>
  <div class="row-fluid">
    <div class="span10">
        <p>Mandrill CMS is operated by NerveCentral Limited  |  <a href="##" title="">Terms &amp; Conditions</a>  | <a href="##" title="">Privacy Policy</a> </p>
        <p>&copy; 2012 NerveCentral Limited. All Rights Reserved. </p>
    </div>
    <div class="span2 mandrill_logo">
        <div class="cms_logo">#imageTag(source="logo-mandrillcms.png", alt="Mandrill CMS")#</div>
    </div>
  </div>
  </footer>

  </body>
</html></cfoutput>