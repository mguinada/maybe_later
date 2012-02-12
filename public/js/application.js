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
});

