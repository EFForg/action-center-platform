//= require blueimp-file-upload/js/vendor/jquery.ui.widget
//= require blueimp-file-upload/js/jquery.fileupload

$(function() {
  $('.gallery').on('click', 'figure', function(e) {
    if (!e.altKey && !e.ctrlKey && !e.metaKey && !e.shiftKey) {
      e.preventDefault();

      var gallery = $(this).closest('.gallery');

      if ($(this).hasClass('selected')) {
        $(this).removeClass('selected');
        gallery.find('input[type=hidden]').removeAttr('value');
        gallery.find('.change img').removeAttr('src');
        gallery.find('.current').removeClass('changed');
      } else {
        gallery.find('.images .selected').removeClass('selected');
        $(this).addClass('selected');

        gallery.find('input[type=hidden]').attr('value', $('img', this).attr('src'));
        gallery.find('.change img').attr('src', $('img', this).attr('src'));
        gallery.find('.current').addClass('changed');
      }
    }
  });

  $('.gallery').on('input', 'input[type=search]', debounce(function(e) {
    var gallery = $(this).closest('.gallery');
    $.ajax({
      method: 'GET',
      url: '/admin/source_files',
      data: { f: encodeURIComponent(e.target.value) },
      success: function(resp) {
        gallery.find('.images ul').replaceWith($(resp));
      }
    });
  }, 200));
});
