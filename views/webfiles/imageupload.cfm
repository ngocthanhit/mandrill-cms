<cfoutput>
     <script type="text/javascript">
        var show = "Images";
     </script>
	#styleSheetLinkTag(sources="blueimp-jQuery-File-Upload/bootstrap-image-gallery.min",head='true')#
	#styleSheetLinkTag(sources="blueimp-jQuery-File-Upload/jquery.fileupload-ui",head='true')#
<!---	<!--[if lt IE 7]>#styleSheetLinkTag(sources="blueimp-jQuery-File-Upload/bootstrap-ie6.min",head='true')#<![endif]--> --->
	<!--[if lt IE 9]><script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.ui.widget",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.tmpl.min",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.load-image",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.canvas-to-blob",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/bootstrap-image-gallery.min",head='false')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.iframe-transport",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.fileupload",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.fileupload-fp",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.fileupload-ui",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/locale",head='true')#
	#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/main",head='true')#
	<!--[if gte IE 8]>#javaScriptIncludeTag(sources="blueimp-jQuery-File-Upload/jquery.xdr-transport",head='true')#<![endif]-->
    <!-- The file upload form used as target for the file upload widget -->
#startFormTag(action="fileUpload",method="POST",enctype="multipart/form-data",id="fileupload",key="Images")#
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
        <div class="row fileupload-buttonbar">
 <cfif NOT isGuest() >
            <div class="span6">
                <!-- The fileinput-button span is used to style the file input field as button -->

                <span class="btn btn-success fileinput-button">
                    <i class="icon-plus icon-white"></i>
                    <span>Add files...</span>
                    #fileFieldTag(name="files[]",multiple="multiple")#
                </span>
                <button type="submit" class="btn btn-primary start">
                    <i class="icon-upload icon-white"></i>
                    <span>Start upload</span>
                </button>
                <button type="reset" class="btn btn-warning cancel">
                    <i class="icon-ban-circle icon-white"></i>
                    <span>Cancel upload</span>
                </button>
              <!---  <button type="button" class="btn btn-danger delete">
                    <i class="icon-trash icon-white"></i>
                    <span>Delete</span>
                </button>
                <input type="checkbox" class="toggle"> --->
            </div>

            <!-- The global progress information -->
            <div class="span5 fileupload-progress fade">
                <!-- The global progress bar -->
                <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                    <div class="bar" style="width:0%;"></div>
                </div>
                <!-- The extended global progress information -->
                <div class="progress-extended">&nbsp;</div>
            </div>
</cfif>
        </div>

        <!-- The loading indicator is shown during file processing -->
        <div class="fileupload-loading"></div>
        <br>
        <!-- The table listing the files available for upload/download -->
        <table role="presentation" class="table table-striped"><tbody class="files" data-toggle="modal-gallery" data-target="##modal-gallery"></tbody></table>
#endFormTag()#
 
	<!-- modal-gallery is the modal dialog used for the image gallery -->
	<div id="modal-gallery" class="modal modal-gallery hide fade" data-filter=":odd">
	    <div class="modal-header">
		<a class="close" data-dismiss="modal">&times;</a>
		<h3 class="modal-title"></h3>
	    </div>
	    <div class="modal-body"><div class="modal-image"></div></div>
	    <div class="modal-footer">
		<a class="btn modal-download" target="_blank">
		    <i class="icon-download"></i>
		    <span>Download</span>
		</a>
		<a class="btn btn-success modal-play modal-slideshow" data-slideshow="5000">
		    <i class="icon-play icon-white"></i>
		    <span>Slideshow</span>
		</a>
		<a class="btn btn-info modal-prev">
		    <i class="icon-arrow-left icon-white"></i>
		    <span>Previous</span>
		</a>
		<a class="btn btn-primary modal-next">
		    <span>Next</span>
		    <i class="icon-arrow-right icon-white"></i>
		</a>
	    </div>
	</div>
	<!-- The template to display files available for upload -->
	<script id="template-upload" type="text/x-tmpl">
	{% for (var i=0, file; file=o.files[i]; i++) { %}
	    <tr class="template-upload fade">
		<td class="preview"><span class="fade"></span></td>
		<td class="name"><span>{%=file.name%}</span></td>
		<td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
		{% if (file.error) { %}
		    <td class="error" colspan="2"><span class="label label-important">{%=locale.fileupload.error%}</span> {%=locale.fileupload.errors[file.error] || file.error%}</td>
		{% } else if (o.files.valid && !i) { %}
		    <td>
		        <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>
		    </td>
		    <td class="start">{% if (!o.options.autoUpload) { %}
		        <button class="btn btn-primary">
		            <i class="icon-upload icon-white"></i>
		            <span>{%=locale.fileupload.start%}</span>
		        </button>
		    {% } %}</td>
		{% } else { %}
		    <td colspan="2"></td>
		{% } %}
		<td class="cancel">{% if (!i) { %}
		    <button class="btn btn-warning">
		        <i class="icon-ban-circle icon-white"></i>
		        <span>{%=locale.fileupload.cancel%}</span>
		    </button>
		{% } %}</td>
	    </tr>
	{% } %}
	</script>
	<!-- The template to display files available for download -->
	<script id="template-download" type="text/x-tmpl">
	{% for (var i=0, file; file=o.files[i]; i++) { %}
	    <tr class="template-download fade">
		{% if (file.ERROR) { %}
		    <td></td>
		    <td class="name"><span>{%=file.NAME%}</span></td>
		    <td class="size"><span>{%=o.formatFileSize(file.SIZE)%}</span></td>
		    <td class="error" colspan="2"><span class="label label-important">{%=locale.fileupload.error%}</span> {%=locale.fileupload.errors[file.error] || file.error%}</td>
		{% } else { %}
		    <td class="preview">{% if (file.THUMBNAIL_URL) { %}
		        <a href="{%=file.URL%}" title="{%=file.NAME%}" rel="gallery" download="{%=file.NAME%}"><img src="{%=file.THUMBNAIL_URL%}" style="max-width:200px;"></a>
		    {% } %}</td>
		    <td class="name">
		        <a href="{%=file.URL%}" title="{%=file.NAME%}" rel="{%=file.THUMBNAIL_URL&&'gallery'%}" download="{%=file.NAME%}">{%=file.NAME%}</a>
		    </td>
		    <td class="size"><span>{%=o.formatFileSize(file.SIZE)%}</span></td>
		    <td colspan="2"></td>
		{% } %}
      		<td class="Add">
               <a class="btn btn-primary AddButton" href="javascript:setval('{%=file.NAME%}','{%=file.SIZE%}','/assets/img/uploadImages/#getAccountAttr('id')#/')" >
		        <i class="icon-plus icon-white"></i>
		        <span >ADD</span>
                </a>
		    </button>
		</td>
	    </tr>
	{% } %}
	</script>

</cfoutput>
<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>

<cfabort>
