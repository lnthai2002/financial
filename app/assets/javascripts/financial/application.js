// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require_tree .
//Show and hide panel body
$(document).ready(function(){
  $( ".datepicker" ).datepicker({ dateFormat: "yy-mm-dd" }).datepicker('setDate', new Date());

  $('.panel-heading.js_collapsable').click(function(e){
    $(e.currentTarget).nextAll('.panel-body:first').slideToggle();
  })
  
  //used in plans listing page
  $(document).on('click', '[data-slide-target]', function(e){
  	var target = $(e.currentTarget).data('slide-target');
  	$(target).slideToggle();
  });

  $(document).on('click', '[data-toggle-target]', function(e){
    var target = $(e.currentTarget).data('toggle-target');
    $(target).toggle();
  })
});