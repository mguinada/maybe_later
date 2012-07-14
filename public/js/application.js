function init() {
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

  //$('a').tooltip();

  $('abbr.timeago').timeago();

  $('a#delete-button').on('click', function() {
    findButtonScope(this).show('fade', 750);
  });

  $('a.no').on('click', function() {
    findButtonScope(this).hide('fade', 500);
  });

  $('a.yes').on('click', function() {
    findButtonScope(this).hide();
  });

  function findButtonScope(obj) {
    return $("ol[dataid=" + $(obj).parents('ol:first').attr('dataid') + "] li.confirm");
  }

  function currentHost() {
    return window.location.protocol + "//" + window.location.host
  }

  $('a.yes').on('click', function(e) {
    if (e.which == 1 && !e.metaKey && !e.shiftKey) {
      $.ajax({
        url: $(this).attr('href'),
        type: $(this).attr('method'),
        dataType: 'script'
      });
    }
    return false;
  });

  /* selected menu item */
  $.each($('#menu a'), function() {
    if($(this).attr('href') == window.location.pathname) {
      $(this).attr('class', 'selected');
    }
  });
}

$(function() {
  /* flash slide down */
  $('div#flash > div').slideDown(500);

  init();
});


