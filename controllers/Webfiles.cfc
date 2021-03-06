component extends="Controller" hint="Controller for crum FILES section" {

    imageext = "jpg,png,gif,jpeg";
    public any function init() hint="Initialize the controller" {
       filters(through="memberOnly");
    }

    public any function index() hint="index default file of webfiles controller" {
        _view(pageTitle = "Files");
    }

    varsiteid = getSiteId();

    private any function fileUpload() hint="files action" {
        var path = "#expandpath("/")#assets/files/uploadfiles/#getAccountAttr("id")#";
        var pathImage = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
        var pathrelative = "/#get('filePath')#/uploadfiles/#getAccountAttr("id")#";
        var pathrelativefiles = "/#get('filePath')#/uploadfiles/#getAccountAttr("id")#";
        var pathrelativeImage = "/#get('imagePath')#/uploadImages/#getAccountAttr("id")#";
        var result = ArrayNew();
        var serverport = CGI.SERVER_PORT ;
        if(serverport != ""){
        	serverport = ":" & CGI.SERVER_PORT & "" ;
        }
        if (GetHttpRequestData().method EQ "GET"){

            if (IsDefined("params.key") AND params.key EQ "Images") {
                 var getfiles = model("file").findall(where="accountid=#getAccountAttr("id")# AND fileext In ('png', 'jpg', 'gif')");
            } else {
                var getfiles = model("file").findall(where="accountid=#getAccountAttr("id")#");
            }


            for (var intRow = 1 ;intRow LTE getfiles.RecordCount ;intRow = (intRow + 1)){
                if(listcontains(imageext,lcase(getfiles[ "fileext" ][ intRow ])) GT 0) {
                    var urlpath = "http://#getPageContext().getRequest().getServerName()##serverport##pathrelativeImage#/#getfiles[ "filename" ][ intRow ]#";
                    var thumbnailUrlPath = "http://#getPageContext().getRequest().getServerName()##serverport##pathrelativeImage#/thumb_#getfiles[ "filename" ][ intRow ]#";
                }else{
                    var urlpath = "http://#getPageContext().getRequest().getServerName()##serverport##pathrelativefiles#/#getfiles[ "filename" ][ intRow ]#";
					var thumbnailUrlPath = urlPath;
                }
                var newlink = structnew() ;
                newlink.name= getfiles[ "filename" ][ intRow ];
                newlink.size= getfiles[ "filesize" ][ intRow ];
                newlink.url= urlpath ;
                if(NOT (isAuthor() && (getfiles[ "userid" ][ intRow ] NEQ getUserAttr("id")) OR isGuest())){
                    newlink.delete_url= URLfor(action="fileUpload", method="DELETE#intRow#",key=getfiles[ "id" ][ intRow ]);
                    newlink.delete_type= "DELETE";
                }
                newlink.thumbnail_url= thumbnailUrlPath;
                newlink.type= 'image/gif';
                arrayappend(result,newlink);
            }
        }
        else if (GetHttpRequestData().method EQ "POST"){
            if (!DirectoryExists(path))
            {
                DirectoryCreate(path);
            }
            var upload =  FileUpload(destination="#path#",fileField="files[]",nameConflict="makeunique");
            var isImageUpload = false;

            if(listcontains(imageext, lcase(upload.serverfileext)) GT 0){
                isImageUpload = true;
                pathrelative = "/#get('imagePath')#/uploadImages/#getAccountAttr("id")#";
                if (!DirectoryExists("#pathImage#")) {
                    DirectoryCreate("#pathImage#");
                }
                FileDelete("#path#/#upload.serverfile#");
                upload = FileUpload(destination="#pathImage#",fileField="files[]",nameConflict="makeunique");

				//create thumbnails
				var imgThumb = ImageNew(pathImage&"/"&upload.serverFile);
				ImageScaleTofit(imgThumb, get('imageUploadThumbWidth'), get('imageUploadThumbHeight'));
				imageWrite(imgThumb, pathImage&"/thumb_"&upload.serverFile);

             }
             var newfile = structnew();
                 newfile.filename = upload.serverfile ;
                 newfile.fileext = lcase(upload.serverfileext) ;
                 newfile.userid =  "#getUserAttr("id")#";
                 newfile.accountid =  "#getAccountAttr("id")#";
                 newfile.title =  '';
                 newfile.filesize =  upload.filesize;
                 insertfile = model("file").new(newfile);

            if (insertfile.save()) {
                _event("I", "Successfully upload file", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                var urlPath = "http://#getPageContext().getRequest().getServerName()##serverport##pathrelative#/#upload.serverfile#";
                var urlThumb = "http://#getPageContext().getRequest().getServerName()##serverport##pathrelative#/thumb_#upload.serverfile#";
                var newlink = structnew() ;
                newlink.name= upload.serverfile;
                newlink.size= upload.filesize;
                newlink.url= urlPath ;
                newlink.delete_url= URLfor(action="fileUpload", method="DELETE",key=insertfile.id);
                newlink.delete_type= "DELETE";
                newlink.thumbnail_url = isImageUpload ? urlThumb : urlPath;
                newlink.type= 'image/gif';
                arrayappend(result,newlink);
            } else{
                _event("E", "Something wrong with file", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                result="error";
            }
        }
        else if (GetHttpRequestData().method EQ "DELETE" OR isDefined("params.key")){
            var getfile = model("file").findbykey(params.key);
            if(isAuthor() && (getfile.userid NEQ getUserAttr("id")) OR isGuest()) {
                _event("W", "Caught attempt to access forbidden member-only page to remove file", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="access denied.") ;
                redirectTo(action="index");
            }

            if(listcontains(imageext,getfile.fileext) GT 0){
                path = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
            }
            if(getfile.userid EQ getUserAttr("id")) {
                _event("I", "successfully removed file", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                FileDelete("#path#/#getfile.filename#");
				if (FileExists("#path#/thumb_#getfile.filename#")) {
                    FileDelete("#path#/thumb_#getfile.filename#");
                }
                getfile.delete();
            }
            result = params.key ;
        }

	    writeoutput(serializejson(result));
	    abort;
    }

    private any function updateimage() hint="Update Image" {
        var getImageSource = ImageRead(Params.newURLLink) ;
        var getimageName = Params.OldName ;
        var path = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
        var newImage = ImageNew(getImageSource) ;

         if (!DirectoryExists("#path#"))
         {
             DirectoryCreate("#path#");
         }

        if (FileExists("#path#/#getimageName#")) {
            getimageName = "#getUserAttr("id")##getAccountAttr("id")##dateformat(now(),"mmddyyyy")##timeformat(now(),"hhmmss")#EDIT.#lcase(listlast(getimageName,"."))#" ;
        }  else {
            getimageName = "#lcase(listfirst(getimageName,"."))#EDIT.#lcase(listlast(getimageName,"."))#" ;
        }
        ImageWrite(newImage,path & "/" & getimageName) ;
        writeOutput("/assets/img/uploadImages/#getAccountAttr("id")#/#getimageName#");
        abort;
    }

    private any function insertlinktoimage() hint="Insert link to image" {
        var getimageName = trim(Params.OldName) ;
        var path = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
        var newImage = "";
        var getImageSource = "";
        var db = false;
        var getImageData = "";
        var newfile = structnew();
        var serverport = CGI.SERVER_PORT ;
        if(serverport != ""){
            serverport = ":" & CGI.SERVER_PORT & "" ;
        }
        if(find("http",lcase(trim(params.newURLLink))) GT 0) {
             getImageSource = ImageRead(trim(Params.newURLLink)) ;
             newImage = ImageNew(getImageSource) ;
        }else if (find("EDIT",getimageName) GT 0) {
             getImageSource = ImageRead("http://#getPageContext().getRequest().getServerName()##serverport#/assets/img/uploadImages/#getAccountAttr("id")#/#getimageName#");
             getimageName = replace(getimageName,"EDIT","");
             newImage = ImageNew(getImageSource) ;
        }
        if(find("http",lcase(trim(Params.newURLLink))) GT 0) {
            if (!DirectoryExists("#path#")) {
                DirectoryCreate("#path#");
            }

            if (FileExists("#path#/#getimageName#")) {
                getimageName = "#getUserAttr("id")##getAccountAttr("id")##dateformat(now(),"mmddyyyy")##timeformat(now(),"hhmmss")#.#lcase(listlast(getimageName,"."))#" ;
            }
            ImageWrite(newImage,path & "/" & getimageName) ;
            db = true;
        } else if (find("EDIT",trim(Params.OldName)) GT 0) {
            FileDelete("#path#/#trim(Params.OldName)#");
            ImageWrite(newImage,path & "/" & getimageName) ;
            db = true;
        }
        getImageData = getFileInfo(path & "/" & getimageName);
        if(db) {
             newfile.filename = getimageName ;
             newfile.fileext = lcase(listlast(getimageName,".")) ;
             newfile.userid =  "#getUserAttr("id")#";
             newfile.accountid =  "#getAccountAttr("id")#";
             newfile.title =  '';
             newfile.filesize =  getImageData.size;
             insertfile = model("file").new(newfile);
                if (insertfile.save()) {
                     _event("I", "Successfully save file", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                }
        }
      writeOutput("http://#getPageContext().getRequest().getServerName()##serverport#/assets/img/uploadImages/#getAccountAttr("id")#/#getimageName#");
        abort;
    }
}
