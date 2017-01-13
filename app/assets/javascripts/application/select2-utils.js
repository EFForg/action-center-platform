$(document).on('ready', function() {
  // Open autocomplete on keypress. For when user tab focuses the element.
  $('body').on('keypress', '.select2-container--focus', function(e) {
    if (e.which >= 32) {
      var $select = jQuery(this).prev();
      $select.select2('open');

      if ($select.prop("multiple"))
        return;

      var $search = $select.data('select2').dropdown.$search || $select.data('select2').selection.$search;
      $search.val(String.fromCharCode(e.which));
      // Timeout seems to be required for Blink
      setTimeout(function() {
        $search.get(0).setSelectionRange(1,1);
        $search.trigger('keyup');
      },0 );
    }
  });

   // Paginate long select menu for snappier experience
  $.fn.select2.amd.define('select2/data/pagedAdapter',
    ['select2/data/array', 'select2/utils'],
    function (ArrayData, Utils) {
      function PagedDataAdapter($element, options) {
        PagedDataAdapter.__super__.constructor.call(this, $element, options);
      }

      Utils.Extend(PagedDataAdapter, ArrayData);

      PagedDataAdapter.prototype.query = function (params, callback) {
        var jsonData = this.options.options.jsonData,
            jsonMap = this.options.options.jsonMap,
            pageSize = 50;

        if (!("page" in params)) {
          params.page = 1;
        }
        var results = $.map(jsonData, function(obj) {
          if(new RegExp(params.term, "i").test(obj[jsonMap.text])) {
            return {
              id:obj[jsonMap.id],
              text:obj[jsonMap.text]
            };
          }
        });
        callback({
          results:results.slice((params.page - 1) * pageSize, params.page * pageSize),
          pagination:{
            more:results.length >= params.page * pageSize
          }
        });
      };

      return PagedDataAdapter;
    });
});
