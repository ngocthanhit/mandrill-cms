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

    </head>
    <body>

        <div class="container">

            <div class="navbar">
                <div class="navbar-inner">
                    <div class="container">
                        <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </a>
                        <a class="brand" href="">Mandrill CMS</a>
                        <div class="nav-collapse">
                            <ul class="nav">
                                <li class="active">#linkTo(text='Dashboard', route="home")#</li>
                                <li><a href="">Pages</a></li>
                                <li><a href="">Posts</a></li>
                                <li><a href="">Files</a></li>
                                <li><a href="">Marketing</a></li>
                                <li><a href="">Users</a></li>
                                <li><a href="">Settings</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            #includeContent()#

            <hr>
            <footer>
                <p>&copy; 2012 NerveCentral Limited</p>
            </footer>
        </div>

    </body>
</html></cfoutput>