component extends="Controller" hint="Controller for crum pages section" {

    public any function init() hint="Initialize the controller" {
	  //  filters(through="memberOnly");
   		writeDump('test1123');
        abort;
    }

    public any function index() hint="Intercept direct access to /pages/" {

		writeDump('test1');
        abort;
	
    }

}
