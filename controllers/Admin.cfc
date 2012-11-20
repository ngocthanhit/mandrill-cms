component extends="Controller" hint="Controller for Administrator section" {


    _view(sectionTitle = "Administrator");

    public any function init() hint="Initialize the controller" {
        filters(through="adminOnly", except="sandbox");
    }



    /*
     * ACCOUNTS & USERS
     */


    include "includes/AdminAccounts.cfm";


    /*
     * BILLING SETTINGS
     */


    include "includes/AdminBilling.cfm";


    /*
     * DATA HISTORY
     */


    include "includes/AdminHistory.cfm";


    /*
     * OTHER ACTIONS
     */


    public any function index() hint="Intercept direct access to /page/" {

        redirectTo(action="syslog");

    }


    public any function sandbox() hint="Testing sandbox" {

        var local = {};

        _view(pageTitle = "Sandbox");

    }



}