if( $("#acq_supplier").length > 0 ){
	let getUrlParameter = function getUrlParameter(sParam) {
		let sPageURL = window.location.search.substring(1),
				sURLVariables = sPageURL.split('&'),
				sParameterName,
				i;
		for (i = 0; i < sURLVariables.length; i++) {
			sParameterName = sURLVariables[i].split('=');
			if (sParameterName[0] === sParam) {
				return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
			}
		}
	};
	let vendor_id = getUrlParameter('booksellerid');
    let options = {
        url: '/api/v1/contrib/acqhistory/acqhistory/vendor/'+vendor_id,
        method: "GET",
        contentType: "application/json",
    };
    $.ajax(options)
        .then(function(result) {
            if( result.length > 0 ){
                $("#supplier-company-details").append('<div id="olib_orders"><h3>OLIB Orders</h3></div>');
                let olib_orders_table = '<table id="olib_orders">'
                                      + '<thead>'
                                      + '<th>Barcode</th>' 
									  + '<th>Order item number</th>' 
                                      + '<th>Gift</th>' 
                                      + '<th>Supplier ID</th>' 
                                      + '</thead>'
                                      + '<tbody>'
                                      + '</tbody>'
                                      + '</table>';
                $("#olib_orders").append(olib_orders_table);
                let order_rows = "";
                result.forEach(function(order,index){
                    order_rows     += '<tr>'
                                   + '<td>' + order.barcode + '</td>'
                                   + '<td>' + order.order_item_no + '</td>'
                                   + '<td>' + (order.gift?"Yes":"No") + '</td>'
                                   + '<td>' + order.supplier_id + '</td>'
                                   + '</tr>';
                       let dog =$("#holdings_table").find('td:contains("'+order.barcode+'")').append(' <i class="fa fa-gift"></i>');
                    });
                    $("#olib_orders table").append(order_rows);
            } else {
                $("#acq_details").append('<h2>No OLIB orders found</h2>');
            }
        })
        .fail(function(err){
             console.log( _("There was an error fetching the resources") + err.responseText );
        });

}
