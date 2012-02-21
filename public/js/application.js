$(function() {
  /* flash slide down */
  $('div#flash > div').slideDown(500);

  /* in-field form label*/
  $('form label').inFieldLabels();

  /* client-side form validation */
  /* TODO: do this plugin-wide */
  $('form').validate({
    errorElement: "span",
    messages: {
        terms: {
          required: 'required'
        },
        email: {
          required: 'required'
        },
        password: {
          required: 'required'
        },
        url: {
          required: 'required'
        },
        title: {
          required: 'required'
        },
    }
  });

  $('a').tooltip();
  
  $('a#delete-button').on('click', function() {    
    findButtonScope(this).show('fade', { direction: 'horizontal' }, 750);
  });

  $('a.no').on('click', function() {    
    findButtonScope(this).hide();
  });

  $('a.yes').on('click', function() {
    alert('ok');
    findButtonScope(this).hide();
  });

  function findButtonScope(obj) {
    return $("ol[dataid=" + $(obj).parents('ol:first').attr('dataid') + "] li.confirm");
  }
});

