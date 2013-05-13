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
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require autocomplete-rails
//= require jquery.ui.dialog
//= require_tree


$(function() {
	$(document).ajaxError(function (e, xhr, settings) {
       // if (xhr.status == 401) {
          $('#notice').html(xhr.responseText);
       // }
    });

/*
 $('.delete-event').bind('ajax:success', function() {  
    $(this).closest('li').slideUp();  
	}); */

$('#eventSubmitButton').bind('ajax:loading', function(){
  $('.loading-gif').show();
});


 $("#createVenueForm").dialog({modal: true, autoOpen: false, minWidth: 400, show: 500});
 $("#createEventForm").dialog({modal: true, autoOpen: false, minWidth: 500, show: 500});
 //$('#suggestVenueLink, .edit-venue').bind('ajax:success', function () {
  //  	$('#createVenueForm').dialog("open");
 //	});


});