//property
//options = {}
//@params
// @target = ID
// options = Options
function isArray(array)
{
  return !(
    !array || 
    (!array.length || array.length == 0) || 
    typeof array !== 'object' || 
    !array.constructor || 
    array.nodeType || 
    array.item 
  );
}
var presence_of = function(target, options) {
  msg = options.name + 'を入力してください';
  valid =  $(target).val() == "" ? false : true;
  return { "message" : msg, "valid" : valid }
}

var acceptance_of = function(target, options){
}

var inclusion_of = function(target, options){
}

var length_of = function(target, options){

}

var email_of = function(target, options){
  regex = /^[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@([a-zA-Z0-9_-]+\.)+[a-zA-Z]{2,4}$/;
  email = $(target).val();
  valid = regex.test(email);
  return { "message" : "メールアドレスの形式で入力してください", "valid" : valid }
}

var Validates = function() {
  this.image = '/assets/check.png';

  this.on_error = function(target, msg){
    $('#notice_' + target).html(msg);
    $('#' + target).addClass("error");
  }

  this.on_success = function(target){
    $('#notice_' + target).html(null);
    $('#' + target).removeClass("error");
    img = $('<img />').attr("src", this.image);
    $('#notice_' + target).append(img);
  }

  this.execute = function(target, func, options){
    elem = $('#' + target);
    if(isArray(func)){
      $.each(func, function(index, f){
        result = f(elem, options);
        if(!result.valid){ return false; }
      })
    }else{
      result = func(elem, options);
    }
    if(result.valid){
      this.on_success(target);
    }else{
      this.on_error(target, result.message);
    }
  }
}

/*
var validates_acceptance_of = function(target){
  if($(target).is(":checked") == true) {
  }
}
*/
/*

var validates_email_of = function(target){
}
*/



function reload_inquiry_agree() {
  if ($("#inquiry_agree").is(":checked") == true) { 
    $("#inquiry_agree").css("outline", "solid 3px #ffffff"); 
    $("#notice_inquiry_agree").html('<img src="/images/check.png" />');
  } else { 
    $("#inquiry_agree").css("outline", "solid 3px #ffcccc"); 
    $("#notice_inquiry_agree").html('同意にチェックがありません。');
  }
  print_button();
}

function reload_inquiry_name() {
  if ($("#inquiry_name").val() == "") { 
    $("#inquiry_name").css("background-color", "#ffcccc"); 
    $("#notice_inquiry_name").html('ご担当者名が入力されていません。');
  } else { 
    $("#inquiry_name").css("background-color", "#ffffff"); 
    $("#notice_inquiry_name").html('<img src="/images/check.png" />');
  }
  print_button();
}

function reload_inquiry_email() {
  if ($("#inquiry_email").val() == "") { 
    $("#notice_inquiry_email").html('メールアドレスが入力されていません。');
    $("#inquiry_email").css("background-color", "#ffcccc"); 
  } else if (email_valid() == false) { 
    $("#notice_inquiry_email").html('メールアドレスが正しくありません。');
    $("#inquiry_email").css("background-color", "#ffcccc"); 
  } else { 
    $("#inquiry_email").css("background-color", "#ffffff"); 
    $("#notice_inquiry_email").html('<img src="/images/check.png" />');
  }
  print_button();
}

function reload_inquiry_body() {
  if ($("#inquiry_body").val() == "") { 
    $("#inquiry_body").css("background-color", "#ffcccc"); 
    $("#notice_inquiry_body").html('お問い合わせ内容が入力されていません。');
  } else { 
    $("#inquiry_body").css("background-color", "#ffffff"); 
    $("#notice_inquiry_body").html('<img src="/images/check.png" />');
  }
  print_button();
}

function print_button() {
  if ( 
       ($("#inquiry_agree").is(":checked")) && ($("#inquiry_name").val() != "") && 
       ($("#inquiry_email").val() != "") && ($("#inquiry_body").val() != "") &&
       ($("#inquiry_body").val() != $("#inquiry_body").attr('title')) &&
       (email_valid() == true)
     ) {
    $("#send_button").css('display', 'inline');
    $("#none_button").css('display', 'none');
  } else {
    $("#none_button").css('display', 'inline');
    $("#send_button").css('display', 'none');
  }
}

function email_valid() {
  var regex = /^[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@([a-zA-Z0-9_-]+\.)+[a-zA-Z]{2,4}$/;
  var email = $("#inquiry_email").val();
  return regex.test(email);
}
