function InfiniteScroll() {
  var page = 1;
  var loading = false;
  var stopped = false;

  function requestPage(pageNum) {
    $('img#page-ajax-loader').show();
    $.ajax({
      url: '/me.js?page=' + pageNum,
      type: 'get',
      dataType: 'script',
      success: postRequest,
      error: postRequest
    });
  }

  function atBottomOfPage() {
    return $(window).scrollTop() > $(document).height() - $(window).height() - 75;
  }

  function postRequest() {
    loading = false;
    $('img#page-ajax-loader').hide();
  }

  function nextPage(force) {
    if(loading || stopped) return;

    if(atBottomOfPage()) {
      loading = true;
      requestPage(++page);
    }
  }

  function halt() {
    stopped = true;
  }

  function restart() {
    stopped = false;
  }

  return {
    page:     page,
    loading:  loading,
    nextPage: nextPage,
    halt:     halt,
    restart:  restart
  }
}