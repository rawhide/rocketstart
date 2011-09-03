$.fn.setupPlaceholder = function() {
  return this.each(function(){
    var input = $(this);
    var title = input.attr("title");
    var edited = false;

    input.bind("focus", function(e) {
      if (!edited && input.val() == title) {
        input.val("");
      }
      input.removeClass("off").addClass("on");
      edited = true;
    }).bind("blur", function(e) {
      if (input.val() == "" || (!edited && input.val() == title)) {
        input.removeClass("on").addClass("off");
        input.val(title);
        edited = false;
      }
   });

    input.parents("form").submit(function(){
      if (!edited && input.val() == title) { input.val(""); }
    });

    input.trigger("blur");
  });
};

$(function() {
  $("#form input:text").setupPlaceholder();
  $("#form textarea").setupPlaceholder();
});

