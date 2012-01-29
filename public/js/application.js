$(function() {
  /* flash slide down */
  $('div#flash > div').slideDown(500);

  /* in-field form label*/
  $('form#signin label').inFieldLabels();

  /* client-side form validation */
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
        }
    }
  });
});

