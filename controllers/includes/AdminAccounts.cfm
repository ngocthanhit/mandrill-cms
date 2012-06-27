<cfscript>



    /*
     * ACCOUNTS & USERS
     */


    public any function accounts() hint="Registered accounts listing" {

        var local = {};

        _view(pageTitle = "Browse Accounts", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Add account", action="accountAdd"));

        initListParams(20, "name");

        accounts = model("account").findAll(
            where="id != #get('visitorsAccountId')#",
            page=params.page,
            perPage=params.pagesize,
            order="#params.order# #params.sort#"
        );

    }


</cfscript>