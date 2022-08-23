if( $("#catalog_detail").length > 0 ){

    let options = {
        url: '/api/v1/contrib/acqhistory/acqhistory/title/'+biblionumber,
        method: "GET",
        contentType: "application/json",
    };
    $.ajax(options)
        .then(function(result) {
            if( result.length > 0 ){
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
                $("#acq_details").append(olib_orders_table);
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
                    $("#olib_orders tbody").append(order_rows);
            } else {
                $("#acq_details").append('<h2>No OLIB orders found</h2>');
            }
        })
        .fail(function(err){
             console.log( _("There was an error fetching the resources") + err.responseText );
        });

}
