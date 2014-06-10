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
//= require jquery.turbolinks

$(document).ready(function(){

  $(document.body).delegate('a.add-to-cart', 'click', function(e){
    var self = this;
    var action_name = $("input#action_name_store").val();
    $.ajax({
      url: $(this).attr('href'),
      type: 'POST',
      data: {'in_action': action_name},
      success: function(response) {
        $('div#box_cart form ul').html(response);
        var count = parseInt($('div#box_cart form ul li input#tick_counter').val());
        if(count > 0) {
          $('div.header li.dropdown a span.badge').html(count);
          $(self).parent("div.jumbotron").append('<div class="alert alert-success">Add to cart successful!</div>');
          $(self).parent("div.jumbotron").find('div.alert').fadeOut(3000);

          $(self).parent('div.product-group-button').append('<div class="alert alert-success">Add to cart successful!</div>');
          $(self).parent('div.product-group-button').find('div.alert').fadeOut(2500);
        } else {

        }
      }
    });
    return false;
  });

  $(document.body).delegate('div.header li.dropdown a.show-cart', 'click', function(e){
    var self = this;
    var action_name = $("input#action_name_store").val();
    if($(this).parents('li.dropdown').hasClass('open')){
      $(this).parents('li.dropdown').removeClass('open');
    }else {
      $.ajax({
        url: $(this).attr('href'),
        type: 'GET',
        data: {'in_action': action_name},
        success: function(response) {
          $(self).parent('li.dropdown').addClass('open');
          $(self).parent('li.dropdown').find('div.dropdown-menu form ul').html(response);
        }
      });
    }

    return false;
  });

  $(document.body).delegate("div#box_cart form ul li a.update-cart", 'click', function(){
    var self = this;
    var json = [];
    $('div#box_cart form ul li div.qty input').each(function(index){
      json.push({id: $(this).data('line-item-id'), qty: $(this).val()});
    });

    $.ajax({
      url: $(this).attr('href'),
      type: 'PUT',
      data: {'json': json},
      success: function(response) {
        if(response){
          $(self).parents('div#box_cart form ul').append('<li class="flash-notice text-center"><div class="alert alert-success">Update successful!</div></li>');
          $(self).parents('div#box_cart form ul').find('li.flash-notice div.alert').fadeOut(2000);
        }else {
          $(self).parents('div#box_cart form ul').append('<li class="flash-notice text-center"><span class="label label-danger">Success</span></li>');
          $(self).parents('div#box_cart form ul').find('li.flash-notice div.alert').fadeOut(2000);
        }
      }
    });
    return false;
  });


  $(document.body).delegate('div#box_cart form ul li div.cart-remove-item', 'click', function(e){
    var self = this;
    $.ajax({
      url: '/frontends/' + $(this).data('line-item-id') + '/remove_item',
      type: 'DELETE',
      success: function(response) {

          $(self).parent().remove();
          $('div.header ul li a.show-cart span.badge').html(response);
          var total_cost = 0;
          $("div#box_cart form ul li div.qty input[type='number']").each(function(index){
            total_cost += (parseInt($(this).val()) * parseInt($(this).data('price')));
          });
          $("div#box_cart form ul li span.total-cost").html(total_cost);

      }
    });
    return false;
  });

  $(document.body).delegate('div#box_cart form ul li div.qty input[type="number"]', 'keyup mouseup', function(){
    var total_cost = 0;
    $("div#box_cart form ul li div.qty input[type='number']").each(function(index){
      total_cost += (parseInt($(this).val()) * parseInt($(this).data('price')));
    });
    $("div#box_cart form ul li span.total-cost").html(total_cost);
  });
});