<script type="text/javascript">
$(document).ready(function(){
    $("#showAddCategorybox").click(function(event) {
        $('<div/>').dialog2({
            title: "Insert Category",
            content: "/index.cfm/categ/",
            id: "Insert_Category"
        });
        event.preventDefault();
    });
})
</script>
<cfoutput>
<!--- heading of the page --->
<h2>#title#</h2>
<!--- show error msg if validation properly work --->
#errorMessagesFor("newPost")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewPostForm",method="post",action=formAction,autocomplete="off")#
<div class="span7">
    <div class="container-fluid" >
     #textArea(label="Main content<br />", objectName="newPost", property="content",class="markItUp",style="width:650px;height:100px")# <br />
    #textField(label="Page Title<br />", objectName="newPost", property="title",size="64")# <br />
    #textArea(label="Description<br />", objectName="newPost", property="description",rows="5", cols="50")# <br />
    #submitTag(name="draft",value="Save as Draft",class="btn SubmitButton")# &nbsp; #submitTag(name="publish",value="Save & Publish",class="btn btn-primary SubmitButton")# <br />
    <cfif NOT StructKeyExists(newPost,"id") >
    #linkto(text="Or publish at a future date ",class="futureDateCont")#
    <div id="futureDateCont">
        <br />
        Publish on date <br />
        #dateTimeSelect(objectName="newPost", property="publisheddate",separator=" at ",timeorder="hour,minute",class="span1")# (24 hour format)<br />
        #submitTag(name="publishDate",value="Save & Publish on Date",class="btn btn-primary SubmitButton")#
    </div>
        <script type="text/javascript">
            toggleDiv('PublishedFutureDateDiv');
        </script>
    <cfelse>
        #hiddenField(objectName="newPost", property="id")#
    </cfif><br />
</div>

</div>
<div class="span4">
        #select(label="Template<br />", objectName="newPost", property="templateid", options=getTemplates)# <br /><br /><br />
        <div class="categories">
        <strong>Categories</strong>&nbsp;&nbsp;&nbsp;#linkTo(text="Add category",id="showAddCategorybox")#<br>
        <cfif IsDefined("newPostCatergory")>
            <cfif isdefined("newPostCatergory.recordcount") AND  newPostCatergory.recordcount gt 0 >
               <cfset categorylist = valuelist(newPostCatergory.categoryid) >   
            <cfelseif isdefined("newPostCatergory") >
                <cfset categorylist =newPostCatergory >
            </cfif>
        <cfelse>
           <cfset categorylist = "" >
        </cfif>
        <cfloop query="ALlCatagories">
            <cfset check = "false">
            <cfif ListfindNoCase(categorylist,ALlCatagories.id) GT 0>
                <cfset check = "true">
            </cfif>
            #checkBoxTag(name="categoryID", label="",labelPlacement="after", value=id ,checked=check)# #category#<br>
        </cfloop>
        </div>
         <cfif StructKeyExists(newPost,"id") >
                 <br />
            <br />
            <br />
            #hiddenfieldTag(name="userid",value="#createdBy.id#")#
            Created by: #linkto(text=createdBy.firstname & " " & createdBy.lastname,controller="users",action="profile",key=createdBy.id)# on #DateFormat(newPost.createdAt,"dd/mm/yyyy")# <br />
            <cfif IsDefined("updatedBy") >
            Last updated by: #linkto(text=updatedBy.firstname & " " & updatedBy.lastname ,controller="users",action="profile",key=updatedBy.id)# on #DateFormat(newPost.updatedat,"dd/mm/yyyy")#<br />
            </cfif>
            Status: #Status.status#<br />
            <br />
     </cfif>
    </div>

#endFormTag()#
<!--- add / edit form page [end]--->
</cfoutput>
<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
