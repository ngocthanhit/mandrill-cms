component extends="Controller" hint="Controller for Account-related actions" {


    _view(sectionTitle = "Your Account");

    public any function init() hint="Initialize the controller" {
        filters(through="accountOwnerOnly");
    }


    public any function index() hint="Intercept direct access to /account/" {

        redirectTo(action="activity");

    }


    public any function activity() hint="Account activity listing" {

        var local = {};

        _view(pageTitle = "Account Activity");

    }
    
    
    
    /*
     * TEAM MEMBERS
     */


    public any function members() hint="Team members listing" {

        var local = {};

        _view(pageTitle = "Team Members", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Add team member", action="memberAdd"));

        initListParams(20, "email");
		writeDump(var=params);abort;
        users = model("users").findAll(
            where = "accountid = #getAccountAttr('id')#",
            page = params.page,
            perPage = params.pagesize,
            order = "#params.order# #params.sort#"
        );

    }
    
    
    
}