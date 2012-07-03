<cfoutput>
     <h2>Files</h2>
     <div class="span12">
          #startFormTag(action="Upload", enctype="multipart/form-data",id="UploadFiles",onsubmit="return ajaxFileUploadcsv('importfilename');",autocomplete="off")#
               <div class="span1">Upload File:</div>
               <div class="span3">#fileFieldTag(name="importfilename",id="importfilename",class="input-file")#</div>
               <div class="span4">#textFieldTag(name="title",id="title")#
               #submitTag(value="Upload", class="btn btn-primary")#<br />
               Filename: (created from file title) #linkTo(text="Edit")#</div>
               <div class="span3">
                    <div class="progress progress-success">
                         <div class="bar" data-percentage="95"></div>
                    </div>
               </div>
          #endFormTag()#
     </div>
     <div class="row-fluid"></div>
     <hr>
     <div class="span5">
         <div class="container-fluid" >
          <h2>Images</h2>
          <table cellpadding="3" width="100%">
          <tbody>
          <cfloop query="getfiles">
               <cfif listcontains(imageext,fileext) gt 0>
                    <tr>
                         <td>#imageTag(source="#pathImage#/#filename#",width="100",height="75")#</td>
                         <td valign="top">
                              <h4>#title# </h4>
                              #filename# <i>(#renderFileSize(#filesize#)#)</i><br />
                              Preview |
                              Edit |
                              #linkTo(text="Download",action="downlaodfile",key="#id#")# |
                              rename |
                              #linkTo(text="Delete",action="Deletefile",key="#id#",confirm="Are you sure you want to delete '#filename#' file.")#

                         </td>
                    </tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
               </cfif>
          </cfloop>
          </tbody>
          </table>
          </div>
     </div>
     <div class="span5" width="100%">
         <div class="container-fluid" >
          <h2>Documents</h2>
          <table cellpadding="3" width="100%">
          <tbody>
          <cfloop query="getfiles">
               <cfif listcontains(imageext,fileext) EQ 0>
                    <tr>
                        <td valign="top">
                              <h4>#title# </h4>
                                 #filename#  <i>(#renderFileSize(#filesize#)#)</i><br />
                              #linkTo(text="Download",action="downlaodfile",key="#id#")# |
                              rename |
                                 #linkTo(text="Delete",action="Deletefile",key="#id#",confirm="Are you sure you want to delete '#filename#' file.")#
                         </td>
                    </tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
               </cfif>
          </cfloop>
          </tbody>
          </table>
          </div>
     </div>
</cfoutput>
<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
