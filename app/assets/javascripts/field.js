//ページ内グローバル変数
function Field(id, title, type, text, par) {
  this.id = id;
  this.title = title;
  this.type = type;
  this.text = text;
  this.html = par.html();
}
fields = new Array();

$(document).ready(function(){
  //ドラッグ＆ドロップ処理
  $(function(){
    $("#print_field").sortable({
      update: function(event, ui) {
        tmp_fields = [];
        a = $('#print_field').sortable('toArray');
        for(i=0; i<a.length; i++) { 
          for(s=0; s<fields.length; s++) {
            if (fields[s].id == a[i]) { tmp_fields.push(fields[s]); }
          }
        }
        fields = tmp_fields;
        create_hidden();
      }
    })
    .disableSelection();
  });  

  //フィールド追加処理
  $("#add_field").click(function(){
    //要素配列の抜きだしと＊がついている要素の処理
    if ($('#elements').val() == "") {
      elements = new Array();
    } else {
      elements = $("#elements").val().split(',');
    }
    re_fg = 0;
    new_elements = new Array();
    for(i=0; i<elements.length; i++) {
      esc = escape(elements[i]);
      re = /^\*/i
      if (re_fg == 0) {
        if (esc.match(re)) { re_fg = 1; }
        new_elements.push(esc);
      } else {
        if (esc.match(re)) {
          new_elements.push(esc.replace('\*', ''));
        } else {
          new_elements.push(esc);
        }
      }
    }
    if (re_fg == 0 && new_elements.length > 0) { new_elements[0] = '*' + new_elements[0] }
    elements_text = ""
    for(i=0;i<new_elements.length;i++) {
      (i == 0) ? (elements_text += new_elements[i]) : (elements_text += '|' + new_elements[i])
    }

    //今回追加するフィールドの識別子発行
    var i = 0;
    var n = 0;
    if (fields.length > 0) {
      for(var key in fields) { if (eval(key) > i) { i = eval(key); } }
      var n = i + 1;
    }

    //作成されたフォームを解析しオブジェクトにプッシュ
    var type = $("#field_type_selected").children(':selected').val();
    var o = create_field(n, escape($("#field_title_textarea").val()), type);
    if ((o.title == '') || (($("#field_title_textarea").attr("title")) == (o.title))) {
      $("#notice").text("項目が入力されていません。").fadeIn("show").fadeOut(5000);
      return false;
    } else if (
                (o.type == "select" || o.type == "radio" || o.type == "checkbox") && 
                ((elements.length < 2) || ($("#elements").val() == $("#elements").attr("title")))
              ) {
      $("#notice").text("セレクトボックス、ラジオボタン、チェックボックスの場合は、要素をカンマ区切りで入力してください。").fadeIn("show").fadeOut(5000);
      return false;
    } else {
      fields.push(o);
      write_html();
      $("#notice").text("項目を追加しました。").fadeIn("show").fadeOut(5000);
    }

    //addボタンを押したときの送信ボタン表示処理
    print_send();

    //レポートタイトルが入力された時の送信ボタンの表示処理
    $("#report_name").bind("blur", function(e) { print_send(); });

  });

  if (fields.length == 0) {
    $("#print_field").append($('<div />').attr('align', 'center').text('フォームを作成してください。')).append('<br />');
  }

});

function print_send() {
  if (($("#report_name").val() == "") || ($("#report_name").val() == $("#report_name").attr("title")) || (fields.length == 0)) {
    $("#send_button").empty();
  } else {
    if (typeof($('#send_button center input#button').val()) == 'undefined') {
      $('#send_button').append($('<center/>').append($('<input />').attr('type', 'submit').attr('id', 'button').val('この内容でフォームを作成する')));
    }
  }
}

function create_field(n, title, selected_type) {
  text = ""
  par = $('<div />');
  if (selected_type == "text") {
    type = "text";
    par.append($('<input />').attr('id', 'print_field_text').attr('type', 'text'));
  } else if (selected_type == "textarea") {
    type = "textarea";
    par.append($('<textarea/>').attr('id', 'print_field_textarea'));
  } else if (selected_type == "select") {
    type = "select";
    text = "[" + elements_text + "]";
    sel = $('<select />');
    for(i=0; i<new_elements.length; i++) { 
      re = /^\*/i
      opt = $('<option />').val(new_elements[i].replace('\*', '')).text(new_elements[i].replace('\*', ''));
      if (new_elements[i].match(re)) {
        opt = opt.attr('selected', 'selected');
      }
      sel.append(opt);
    }
    par.append(sel);
  } else if (selected_type == "radio") {
    type = "radio";
    text = "[" + elements_text + "]";
    for(i=0; i<new_elements.length; i++) { 
      re = /^\*/i
      radio = $('<input />').attr('type', 'radio').attr('name', n);
      if (new_elements[i].match(re)) {
        radio = radio.attr('checked', 'checked');
      }
      par.append(radio);
      par.append(new_elements[i].replace('\*', '') + "&nbsp;");
    }
  } else if (selected_type == "checkbox") {
    type = "checkbox";
    text = "[" + elements_text + "]";
    for(i=0; i<new_elements.length; i++) { 
      re = /^\*/i
      chk = $('<input />').attr('type', 'checkbox');
      if (new_elements[i].match(re)) {
        chk.attr('checked', 'checked');
      }
      par.append(chk);
      par.append(new_elements[i].replace('\*','') + "&nbsp;");
    }
  } else if (selected_type == "date") {
    type = "date";
    par.append($('<input />').attr('type', 'text'));
  } else if (selected_type == "date-date") {
    type = "date-date";
    inp = $('<input />').attr('type', 'text');
    par.append(inp);
    par.append('〜');
    par.append(inp);
  } else if (selected_type == "hour") {
    type = "hour";
    sel = $('<select />');
    for (i=0;i<24;i++) {
      sel.append($('<option />').text(i + ':00'));
    }
    html += "</select>"
    par.append(sel);
  } else if (selected_type == "hour-hour") {
    type = "hour-hour";
    sel1 = $('<select />');
    sel2 = $('<select />');
    for (i=0;i<24;i++) {
      opt = $('<option />').text(i + ':00');
      sel1.append(opt);
      sel2.append(opt); 
    }
    par.append(sel1);
    par.append('〜');
    par.append(sel2);
  } else if (selected_type == "birthday") {
    type = "birthday";
    sel = $('<select />');
    for (i=1;i<13;i++) {
      sel.append($('<option />').text(i));
    }
    par.append(sel);
    par.append('月')
    sel = $('<select />');
    for (i=1;i<32;i++) {
      sel.append($('<option />').text(i));
    }
    par.append(sel);
    par.append('日');
  }
  f = new Field(n, title, type, text, par);
  return f;
}

//オブジェクトの内用をHTMLに出力
function write_html() {
  $("#print_field").empty();

  par = $('<div />');
  for(i=0; i<fields.length; i++) {
    div = $('<div />').attr('id', fields[i].id).attr('class', 'field');
    div.append($('<div />').attr('id', 'field_title').text(fields[i].title));
    div.append($('<div />').attr('id', 'field_html').html(fields[i].html));
    icon = $('<div />').attr('id', 'field_icon');
    img  = $('<img />').attr('src', '/images/s_error.png');
    a    = $('<a />').attr('href', 'javascript:void(0);').attr('onclick', 'remove_field(' + fields[i].id + ');');
    icon.append(a.append(img));
    div.append(icon);
    par.append(div);
  }
  $("#print_field").append(par.html())
  create_hidden();
  print_send();
}

function remove_field(n) {
  var i = 0;
  for(i=0; i<fields.length; i++) {
    if (eval(fields[i].id) == eval(n)) { fields.splice(i, 1); }
  }
  if (fields.length == 0) {
    $("#send_button").empty();
  }
  write_html();
  create_hidden();
  $("#notice").text("フォームを削除しました。").fadeIn("show").fadeOut(5000);
  if (fields.length == 0) {
    $("#print_field").append($('<div />').attr('align', 'center').text('フォームを作成してください。')).append('<br />');
  }
}

function create_hidden() {
  $("#hidden").empty();
  par = $('<div />');
  for(i=0; i<fields.length; i++) {
    par.append($('<input />').attr('type', 'hidden').attr('name', 'field["' + fields[i].id + '"][title]').val(fields[i].title));
    par.append($('<input />').attr('type', 'hidden').attr('name', 'field["' + fields[i].id + '"][form_type]').val(fields[i].type));
    par.append($('<input />').attr('type', 'hidden').attr('name', 'field["' + fields[i].id + '"][text]').val(fields[i].text));
  }
  $("#hidden").append(par.html());
}

function escape(string) {
   return string.replace(/&/g, '&amp;')
                .replace(/"/g,  '&quot;')
                .replace(/'/g,  '&#039;')
                .replace(/:/g,  '：')
                .replace(/\[/g,  '（')
                .replace(/\]/g,  '）')
                .replace(/\|/g,  '｜')
                .replace(/,/g,  '、')
                .replace(/@/g,  '＠')
                .replace(/</g,  '&lt;')
                .replace(/>/g,  '&gt;');
}
