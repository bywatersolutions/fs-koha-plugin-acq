if( $("#catalog_moredetail").length > 0 ){
    $("ol.bibliodetails:contains('Current library:')").each(function(){  
        let biblionumber = $(this).find('input[name="biblionumber"]').first().val();
        let biblioitemnumber = $(this).find('input[name="biblioitemnumber"]').first().val();
        let itemnumber = $(this).find('input[name="itemnumber"]').first().val();
        if( itemnumber ){
            let nfl = '<li><span class="label">Not for loan status: </span>';
            nfl += '<select data-itemnumber="'+itemnumber+'" id="item_nfl_'+itemnumber+'">';
            nfl += '<option value="0">None (for loan)</option>';
            nfl += '<option value="1">Storage</option>';
            nfl += '<option value="2">Waiting for Storage</option>';
            nfl += '<option value="3">Scanning</option>';
            nfl += '<option value="4">In Transit</option>';
            nfl += '<option value="5">Cataloging</option>';
            nfl += '<option value="6">Security Copy</option>';
            nfl += '<option value="9">In a Bound Volume</option>';
            nfl += '<option value="10">To Be Scanned</option>';
            nfl += '<option value="11">To Be Reviewed</option>';
            nfl += '<option value="12">Vault Master</option>';
            nfl += '</select><a class="btn btn-sm nfl_update">Update</a></li>';
            let statuses = $(this).append(nfl);
        }
        $.get('/api/v1/items?q={"biblionumber":{"=":"'+biblionumber+'"}}&_per_page=-1',function(data){
            data.forEach(function(e){
                    console.log(e);
                $('#item_nfl_'+e.item_id).val(e.not_for_loan_status).data('nfl',e.not_for_loan_status);
            });
        });

    });

    $("#catalog_moredetail").on('click','.nfl_update',function(){
        let the_select = $(this).parent().find('select');
        let itemnumber = the_select.data("itemnumber");
        let old_nfl = the_select.data('nfl');
        let new_nfl = the_select.val();
        $.post('/api/v1/contrib/acqhistory/update_nfl/'+itemnumber, JSON.stringify({ "notforloan": new_nfl }) )
            .done(function(data){
                alert('Not for loan status updated');
                the_select.data('nfl',new_nfl);
            })
            .fail(function(data){
                alert('Could not update:' + data.responseText);
                the_select.val( old_nfl );
            });
    });

}
