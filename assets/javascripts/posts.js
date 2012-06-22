// JavaScript Document

function toggleDiv(id)
{
	var elementID = document.getElementById(id);
	if(elementID.style.display == 'none')
	{
		elementID.style.display='block';
	}
	else
	{
		elementID.style.display='none';	
	}
	return false;
}

