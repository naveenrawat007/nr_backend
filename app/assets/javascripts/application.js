// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery
//= require turbolinks
//= require_tree .

$(document).ready(function(){

  $("#submit").click(function(e){
    var email = $("#email").val()
    var fname = $("#fname").val()
    var lname = $("#lname").val()
    var phone = $("#phone").val()
    var regex =  /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

    if ((!/^[a-zA-Z]*$/g.test(fname)) || (!/^[a-zA-Z]*$/g.test(lname))) {
        let a = "Invalid Name";
        alert(a);
        e.preventDefault()
    }
    else if((!regex.test(email)) && (!email.length < 1)){
      let a = "Invalid Email";
      alert(a);
      e.preventDefault()
    }else if ((!/^[0-9]+$/.test(phone)) && (!phone.length < 1)){
      let a = "Invalid Phone Number";
      alert(a);
      e.preventDefault()
    }
  })

})
