(function() {
  this.step = $(".step_box").size();
  this.drag = function() {
    return $("#workflows").sortable({
      update: function(event, ui) {
        return init_step();
      }
    });
  };
  this.props = {
    1: "個人情報保護責任者",
    2: "社長",
    3: "教育責任者",
    4: "情報システム・リスク責任",
    5: "従業員"
  };
  this.make_options = function(select_ele, step) {
    return $.each(props, function(k, v) {
      var opt;
      opt = $("<option />").attr("name", "approval_form[workflow_templates_attributes[" + step + "][user_type]").val(k).text(v);
      return select_ele.append(opt);
    });
  };
  this.remove_step = function(step) {
    $('#step_box' + step).remove();
    step = $(".step_box").size() - 1;
    return init_step();
  };
  this.add_step = function() {
    var actor_select, box, remove_span, step, step_hidden, step_span;
    step = $(".step_box").size() + 1;
    box = $('<div />').attr('id', 'step_box' + step).attr("class", "step_box");
    step_span = $('<span />').html("ステップ").append($('<input />').attr("type", "text").attr("disabled", "disabled").attr("size", 1).val(step));
    step_hidden = $('<input />').attr('type', 'hidden').attr('name', "approval_form[workflow_templates_attributes[" + step + "][step]").val(step);
    actor_select = $('<select />');
    make_options(actor_select, step);
    remove_span = $('<span />').append($('<a />').attr('href', 'javascript:void(0);').attr('onclick', "remove_step(" + step + ")").text("×"));
    box.append(step_span) && box.append(actor_select) && box.append(step_hidden);
    if (step > 1) {
      box.append(remove_span);
      $("#workflows").append(box);
      return init_step();
    }
  };
  this.init_step = function() {
    var ini_step;
    ini_step = 1;
    return $.each($(".step_box input"), function(i, ele) {
      if (ele.size === 1) {
        ele.value = ini_step;
      }
      if (ele.type === "hidden") {
        ele.value = ini_step;
        return ini_step++;
      }
    });
  };
  drag();
}).call(this);