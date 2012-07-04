component extends="Controller" hint="Controller for crum FILES section" {

     imageext = "jpg,png,gif,jpeg";
     public any function init() hint="Initialize the controller" {
       filters(through="memberOnly");
    }

     public any function index() hint="Initialize the controller" {
     getfiles = model("file").findall(where="accountid=#getAccountAttr("id")#");
     path = "/assets/files/uploadfiles/#getAccountAttr("id")#";
     pathImage = "uploadImages/#getAccountAttr("id")#";
    }

       public any function upload() hint="Initialize the controller" {
     if ( (NOT isdefined("params.importfilename")) OR params.importfilename EQ ""){
           WriteOutput(serializeJson("error"));     
           abort;
     }
     if ( (NOT isdefined("params.title")) OR params.title EQ ""){
           WriteOutput(serializeJson("error"));     
           abort;
     }
        path = "#expandpath("/")#assets/files/uploadfiles/#getAccountAttr("id")#";
     pathImage = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
        if (!DirectoryExists(path))
        {
            DirectoryCreate(path);
        }
     var upladfiledetail =  FileUpload(destination="#path#",fileField="#params.importfilename#",nameConflict="makeunique");
     if(listcontains(imageext,lcase(upladfiledetail.serverfileext)) GT 0){
           if (!DirectoryExists("#pathImage#"))
             {
                 DirectoryCreate("#pathImage#");
             }  
          FileDelete("#path#/#upladfiledetail.serverfile#");
          upladfiledetail =  FileUpload(destination="#pathImage#",fileField="#params.importfilename#",nameConflict="makeunique");
     }
     var file = structnew();
     file.filename = upladfiledetail.serverfile ;
     file.fileext = lcase(upladfiledetail.serverfileext) ;
     file.userid =  getUserAttr("id");
     file.accountid =  getAccountAttr("id");
     file.title =  params.title;
     file.filesize =  upladfiledetail.filesize;
     var insertfile = model("file").new(file);
     if (insertfile.save())
     {
           WriteOutput(serializeJson("success"));
     }
     else
     {
           WriteOutput(serializeJson("error"));
     }
        abort;
    }
     public any function downlaodfile() hint="downalod image files"{
          var getfile = model("file").findbykey(params.key);
          var path = "assets/files/uploadfiles/#getAccountAttr("id")#";
          if(listcontains(imageext,getfile.fileext) GT 0){
              path = "assets/img/uploadImages/#getAccountAttr("id")#";
          }
          sendFile(directory="#path#",file="#getfile.filename#");
   }
     public any function Deletefile() hint="downalod image files"{
          var getfile = model("file").findbykey(params.key);
           if(isAuthor() && (getfile.userid NEQ getUserAttr("id")) OR isGuest())
               {
                    flashInsert(success="access denied.") ;
                    redirectTo(action="index");
                }

          var path = "#expandpath("/")#assets/files/uploadfiles/#getAccountAttr("id")#";
          if(listcontains(imageext,getfile.fileext) GT 0){
              path = "#expandpath("/")#assets/img/uploadImages/#getAccountAttr("id")#";
          }
            if(getfile.userid EQ getUserAttr("id")) {
                  FileDelete("#path#/#getfile.filename#");
                  getfile.delete();
                  flashInsert(success="file deleted successfully.") ;
                }else{
                  flashInsert(success="access denied.") ;
                }
          redirectTo(action="index");
   }
     public any function renderFileSize(
                         numeric size ,
                         string type = 'bytes'
                         ) hint="Returns file size in either b, kb, mb, gb, or tb"{
          
          local.newsize = ARGUMENTS.size;
          local.filetype = ARGUMENTS.type;
          do{
               local.newsize = (local.newsize / 1024);
               if(local.filetype IS 'bytes')local.filetype = 'KB';
               else if(local.filetype IS 'KB')local.filetype = 'MB';
               else if(local.filetype IS 'MB')local.filetype = 'GB';
               else if(local.filetype IS 'GB')local.filetype = 'TB';
          }while((local.newsize GT 1024) AND (local.filetype IS NOT 'TB'));
          local.filesize = REMatchNoCase('[(0-9)]{0,}(\.[(0-9)]{0,2})',local.newsize);
          if(arrayLen(local.filesize))return local.filesize[1] & ' ' & local.filetype;
          else return local.newsize & ' ' & local.filetype;
          return local;
     }

}

