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
        <link href="/#get('stylesheetPath')#/jquery.ui.css" rel="stylesheet">
        <link href="/#get('stylesheetPath')#/bootstrap-responsive.css" rel="stylesheet">
        #styleSheetLinkTag("src/bootstrap-wysihtml5")#
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
        <script type="text/javascript" src="http://feather.aviary.com/js/feather.js"></script>
        #javaScriptIncludeTag("jquery,jquery.ui,layout,mandrillcms,lib/js/wysihtml5-0.3.0,src/bootstrap-wysihtml5")#
        #javaScriptIncludeTag("bootstrap,jquery.dialog2")#
    </head>
<body>
    <div class="modal hide" id="myModal" style="z-index:10001;">
       <div class="modal-body">
        <p align="center">#imageTag("ajax-loader.gif")#Loading...</p>
       </div>
    </div>
        <div class="container">
        <cfif isLoggedIn()>#includePartial("/shared/navigation")#</cfif>
            <cfif view.renderCustomLayout>
                #includeContent()#
            <cfelse>
                <div>
                    <div>
                        <h2>#view.pageTitle#<cfif view.pageTitleAppend NEQ ""> #view.pageTitleAppend#</cfif></h2>
                        <ul>
                            <cfif view.renderShowBy>
                            <li class="active">
                                Show by:
                                <cfloop list="#get('showBySize')#" index="p">
                                #linkTo(text=p, params="pagesize=#p#", class=iif(params.pagesize EQ p, De('active'), De('')), key=view.showByKey, controller=view.showByController)#
                                </cfloop>
                            </li>
                            </cfif>
                            <cfloop array="#view.headLinks#" index="hlink">
                            <li>#hlink#</li>
                            </cfloop>
                        </ul>
                    </div>

                    <div class="well content">

                        <cfif view.renderFlash>#flashRender()#</cfif>

                        #includeContent()#

                    </div>

                </div>

            </cfif>

            <hr>
            <footer>
                <p>&copy; 2012 NerveCentral Limited</p>
            </footer>
        </div>
</body>
</html></cfoutput>
