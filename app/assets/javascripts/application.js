// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require turbolinks
//= require bootstrap
//= require_tree .
//= require highcharts/highcharts                                                           
//= require highcharts/highcharts-more                                                         
//= require highcharts/highstock

//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.position



$('document').ready(function() {

  $("#sendToTopPage").click(function(){
    $(window).scrollTop(0);
   });


});


function showDialogAddTransaction(){
    $("#addTransaction").dialog();
    return false;
};

function showInviteUserToAccount(id){
    $("#inviteUserToAccount"+id).dialog();
    return false;
};



function handleChange(myRadio) {
    if(myRadio.value == 'income') {
        $('.class_select_income').css('display', 'block');
        $('.class_select_expense').css('display', 'none');

    }
    else {
        $('.class_select_income').css('display', 'none');
        $('.class_select_expense').css('display', 'block');
    }
}

 