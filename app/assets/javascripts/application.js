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
//= require jquery.ui.dialog
//= require turbolinks
//= require bootstrap
//= require_tree .
//= require highcharts/highcharts                                                           
//= require highcharts/highcharts-more                                                         
//= require highcharts/highstock


$('document').ready(function() {

  $("#sendToTopPage").click(function(){
    $(window).scrollTop(0);
   });

  $('#treeCategories').tree({ dataSource: dataSource })
  /*
  var dataSource = new StaticDataSource({
            columns: [
                {
                    property: 'username',
                    label: 'Name',
                    sortable: true
                },
                {
                    property: 'username',
                    label: 'Country',
                    sortable: true
                },
            data: this.collection,
            delay: 250
        });
        $('#MyGrid').datagrid({
            dataSource: dataSource,
            stretchHeight: true
        });*/


});


function showDialogAddTransaction(){
    $("#addTransaction").dialog();
    return false;
}



