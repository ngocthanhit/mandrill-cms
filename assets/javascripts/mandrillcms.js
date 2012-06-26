
// function to toggle "published on future date" div
function toggleDiv(id)
{
    var elementID = document.getElementById(id);
    if(elementID.style.display == 'none')
    {
        $(".btn-primary").eq(0).removeClass("btn-primary");
        $("#" + id).show();
    }
    else
    {
        $(".btn").eq(1).addClass("btn-primary");
        $("#" + id).hide();
    }
    return false;
}
