$(function () {
	
	
	// Init date pickers on page
	var date_pickers = $('input.date_picker');
	if (date_pickers.length) {
		date_pickers.datepicker({dateFormat: 'dd M yy', showButtonPanel: true});
	}
		

});