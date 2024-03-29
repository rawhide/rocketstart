/*
  FormPresenter

  対応しているインプットタイプ
    1,text
    2,textarea
  
  対応していないインプットタイプ
    1,selectbox
    2,checkbox
    3,radio
*/

function FormPresenter(image, h) {
  var image = image;
  var hash = h;
  var status = [];

  this.load = function() {
    for (var k in hash) { 
      _reload(k); 
      status[k] = false;
      if (hash[k]["place_holder"]) {
        ph = hash[k]["place_holder"];
        new PlaceHolder(k, ph["msg"], ph["css"]);
      }
    }
    return this;
  }

  this.event_watch = function() {
    for (var k in hash) {
      e = hash[k]["event"];
      if (e == "click") {
//ここでHTMLからinput typeを取得してradio, select, checkboxだったら、idを正規表現で処理すす。
        $("#" + k).click(function(){ _reload(this.id); });
      } else if (e == "keyup") {
//ここでHTMLからinput typeを取得してradio, select, checkboxだったら、idを正規表現で処理すす。
        $("#" + k).keyup(function(){ _reload(this.id); });
      }
    }
    return this;
  }

  //HTMLからのreloadメソッドインターフェース
  this.reload = function(k) {
    _reload(k);
    return this;
  }

  var _reload = function(k) {
    vs = hash[k]["validations"];
    for (i=0; i< vs.length; i=i+1) {
      type = vs[i]["type"];
      if      (type == "not_null")     { not_null(k, vs[i]);     }
      else if (type == "email_format") { email_format(k, vs[i]); }
      else if (type == "checked")      { checked(k, vs[i]);      }
    }
  }

  var not_null = function(k, vs) {
    if ($("#" + k).val() == "") { print_notice(k, vs); } 
    else { print_success(k, vs); }
  }

  var email_format = function(k, vs) {
    regex = /^[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@([a-zA-Z0-9_-]+\.)+[a-zA-Z]{2,4}$/;
    email = $("#" + k).val();
    if (regex.test(email)) { print_success(k, vs); } 
    else { print_notice(k, vs); }
  }

  var checked = function(k, vs) {
    alert("mmm");
    if ($("#" + k).is(":checked") == true) { print_success(k, vs); } 
    else { print_notice(k, vs); }
  }

  var print_notice = function(k, vs) {
    css = hash[k]["highlight_css"];
    for (i=0; i<css.length; i=i+1) { 
      c = css[i].split(":");
      $("#" + k).css(c[0], c[1]); 
    }
    $("#notice_" + k).html(vs["msg"]);
    status[k] = false;
    print_button();
  }

  var print_success = function(k, vs) {
    css = hash[k]["normal_css"];
    for (i=0; i<css.length; i=i+1) { 
      c = css[i].split(":");
      $("#" + k).css(c[0], c[1]); 
    }
    $("#notice_" + k).html('<img src="' + image + '" />');
    status[k] = true;
    print_button();
  }

  var print_button = function() {
    next_fg = true;
    for (var k in hash) {
      if (status[k] == false) { next_fg = false; }
    }
    if (next_fg == true) {
      $("#send_button").css('display', 'inline');
      $("#none_button").css('display', 'none');
    } else {
      $("#send_button").css('display', 'none');
      $("#none_button").css('display', 'inline');
    }
    hoge();
  }

  var hoge = function() {
    text = "";
    for (var s in status) {
      text = text + "\n" + s + "=" + status[s];
    }
    alert(text);
  }

}

function PlaceHolder(k, msg, css) {
  $('#' + k)
    .blur(function(){
      var $$=$(this);
      if($$.val()=='' || $$.val()==msg){
        for (i=0; i<css.length; i=i+1) {
          c = css[i].split(":");
          $$.css(c[0], c[1]).val(msg);
        }
      }
    })
    .focus(function(){
      var $$=$(this);
      if($$.val()==msg){
        $$.css('color', '#000').val('');
      }
    }).parents().end().blur();
}
