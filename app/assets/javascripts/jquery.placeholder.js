(function($){
  $.fn.placeholder = function(opts){
    
    if(typeof opts == 'string') {
      opts = {word:opts};
    }
    opts = $.extend({
      word: '',
      styleClass: 'placeholder'
    },opts);
    
    return this.each( function() {
      $(this).blur(
        function(){
          if(changed(this)) return;
          $(this).addClass(opts.styleClass).val(opts.word);
        }
      ).focus(
        function(){
          if(changed(this)) return;
          $(this).removeClass(opts.styleClass).val('');
        }
      ).blur();
      
      $(this).parents('form').bind('submit', $(this), function(event){
        event.data.triggerHandler('focus');
      });
      
    });
    
    function changed(elem) {
      if($(elem).val() == ''){
        return false;
      }else if($(elem).val() == opts.word && $(elem).hasClass(opts.styleClass)){
        return false;
      }
      return true;
    }
  };
  
  $(function(){
    $(':text[placeholder]').each(function(){
      $(this).placeholder({
        word: $(this).attr('placeholder'),
        styleClass: 'placeholder'
      });
    });
  });
})(jQuery);
