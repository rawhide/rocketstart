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
       ($("#inquiry_body").val() != $("#inquiry_body").attr('title')) 
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
