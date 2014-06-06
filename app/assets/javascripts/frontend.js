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
//= require turbolinks
//= require bootstrap
//= require jquery.fancybox
//= require jquery.fancybox.pack

$(document).ready(function(){

  $(document.body).delegate('a.ajax-link', 'click', function(e) {
    var self = this;
    $.fancybox({
      type: 'ajax',
      href: $(self).data('url'),
      // modal: true,
      autoDimensions: false ,
      changeSpeed: 100,
      autoScale: false,
      titleShow: true
    });
    return false;
  });

  // $(document.body).delegate('button.show-products', 'click', function(e){
  //   $.ajax({
  //     url: "/frontends/" + $(this).data('category-id') + "/products_by_category",
  //     type: 'GET',
  //     success: function(response) {
  //       $('#stage').html(response);
  //     }
  //   });

  //   return false;
  // });

  // $(document.body).delegate('ul.pagination li.page a, ul.pagination li.last a, ul.pagination li.first a, ul.pagination li.next a, ul.pagination li.prev a', 'click', function(e){
  //   $.ajax({
  //     url: $(this).attr('href'),
  //     type: 'GET',
  //     success: function(response) {
  //       $("#stage").html(response);
  //     }
  //   });
  //   return false;
  // });

  // $(document.body).delegate('a.thumbnail', 'click', function(e){
  //   $.ajax({
  //     url: '/frontends/' + $(this).data('product-id') + '/show_product',
  //     type: 'GET',
  //     success: function(response) {
  //       $("#stage").html(response);
  //     }
  //   });
  //   return false;
  // });

});