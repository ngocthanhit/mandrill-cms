component extends="Controller" hint="Controller for crum FILES section" {

     imageext = "jpg,png,gif,jpeg";
     public any function init() hint="Initialize the controller" {
       filters(through="memberOnly");
    }

    private any function fileUpload() hint="files action" {
        var path = "#expandpath("/")#assets/files/uploadfiles/#getAccountAttr("id")#";
        var pathImage = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
        var pathrelative = "/assets/files/uploadfiles/#getAccountAttr("id")#";
        var pathrelativefiles = "/assets/files/uploadfiles/#getAccountAttr("id")#";
        var pathrelativeImage = "/assets/img/uploadImages/#getAccountAttr("id")#";
        var result = ArrayNew();
        if (GetHttpRequestData().method EQ "GET"){
            var getfiles = model("file").findall(where="accountid=#getAccountAttr("id")#");
            for (intRow = 1 ;intRow LTE getfiles.RecordCount ;intRow = (intRow + 1)){
                if(listcontains(imageext,lcase(getfiles[ "fileext" ][ intRow ])) GT 0) {
                    urlpath = "http://localhost#pathrelativeImage#/#getfiles[ "filename" ][ intRow ]#";
                }else{
                    urlpath = "http://localhost#pathrelativefiles#/#getfiles[ "filename" ][ intRow ]#";
                }
                var newlink = structnew() ;
                    newlink.name= getfiles[ "filename" ][ intRow ];
                    newlink.size= getfiles[ "filesize" ][ intRow ];
                    newlink.url= urlpath ;
                    newlink.delete_url= URLfor(action="fileUpload", method="DELETE#intRow#",key=getfiles[ "id" ][ intRow ]); 
                    newlink.delete_type= "DELETE";
                    newlink.thumbnail_url= urlpath;
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

               if(listcontains(imageext,lcase(upload.serverfileext)) GT 0){
                pathrelative = "/assets/img/uploadImages/#getAccountAttr("id")#";
               if (!DirectoryExists("#pathImage#"))
                 {
                 DirectoryCreate("#pathImage#");
                 }
              FileDelete("#path#/#upload.serverfile#");
              upload =  FileUpload(destination="#pathImage#",fileField="files[]",nameConflict="makeunique");
             }
             var newfile = structnew();
                 newfile.filename = upload.serverfile ;
                 newfile.fileext = lcase(upload.serverfileext) ;
                 newfile.userid =  "#getUserAttr("id")#";
                 newfile.accountid =  "#getAccountAttr("id")#";
                 newfile.title =  'test';
                 newfile.filesize =  upload.filesize;
                 insertfile = model("file").new(newfile);

             if (insertfile.save())
                {
                  var urlPath = "http://localhost#pathrelative#/#upload.serverfile#";
                  var newlink = structnew() ;
                    newlink.name= upload.serverfile;
                    newlink.size= upload.filesize;
                    newlink.url= urlPath ;
                    newlink.delete_url= URLfor(action="fileUpload", method="DELETE",key=insertfile.id); 
                    newlink.delete_type= "DELETE";
                    newlink.thumbnail_url= urlpath;
                    newlink.type= 'image/gif';
                arrayappend(result,newlink);

                }
            else{
                result="error";
            }
        }
        else if (GetHttpRequestData().method EQ "DELETE" OR isDefined("params.key")){
            var getfile = model("file").findbykey(params.key);
               if(isAuthor() && (getfile.userid NEQ getUserAttr("id")) OR isGuest())
                   {
                    flashInsert(success="access denied.") ;
                    redirectTo(action="index");
                }

              if(listcontains(imageext,getfile.fileext) GT 0){
                  path = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
              }
                if(getfile.userid EQ getUserAttr("id")) {
                  FileDelete("#path#/#getfile.filename#");
                  getfile.delete();
                 }
            result = params.key ;
        }
    writeoutput(serializejson(result));
    abort;
    }

}
