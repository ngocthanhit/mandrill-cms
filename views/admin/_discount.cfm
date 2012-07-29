<cfoutput>
#flashRender("discount")#

<fieldset>

    <p>
        #textField(label="Discount Name", objectName="discount", property="name", class="required text small", prepend="<br />")#
        #noteText("Name should be short enough to fit the client's GUI.", "<br/>")#
    </p>

    <p>
    <cfif discount.isUsed()>
        #textField(label="Discount (%)", objectName="discount", property="discount", class="text nano", prepend="<br />", disabled="disabled")#
        #noteText("It is possible to change value only for discounts which have never been used.", "<br/>")#
    <cfelse>
        #textField(label="Discount (%)", objectName="discount", property="discount", class="required text nano", prepend="<br />")#
    </cfif>
    </p>

    <p>
        #textField(label="Coupon Code", objectName="discount", property="coupon", class="text small", prepend="<br />")#
        #noteText("Usually used along with expiration date.", "<br/>")#
    </p>

    <p>
        #textField(label="Expires On", objectName="discount", property="expirationDate", class="text date_picker", prepend="<br />")#
        #noteText("Set blank to have discount never expired.", "<br/>")#
    </p>

    <p>
        #textArea(label="Description", objectName="discount", property="description", class="small", prepend="<br />")#
    </p>

    <p>
        #checkBox(label=" Discount is Active", objectName="discount", property="isactive", checkedValue="1", uncheckedValue="0", class="checkbox", labelPlacement="after")#
        #noteText("Inactive discount cannot be applied any more.", "<br/>")#
    </p>

    <p>
        #submitTag(class="submit long", value=view.buttonLabel)#
        <cfif NOT discount.isNew() AND NOT discount.isUsed()>
        #linkTo(text="Delete Discount", action="discountDelete", key=params.key, class="button long-red", confirm="Are you sure you want to delete this discount completely?")#
        </cfif>
        #noteText("It is possible to delete only discounts which have never been used.", "<br/>")#
    </p>

</fieldset>

<script type="text/javascript">
$(document).ready( function(){
    $(".required").requiredInput();
});
</script>
</cfoutput>