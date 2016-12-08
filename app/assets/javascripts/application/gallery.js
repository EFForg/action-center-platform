$(function() {
  function attachGalleryImage(modal, input, div) {
    var modal = $(modal);
    var input = $(input);
    var div = $(div);
    var button = div.find('.attach-gallery-image');
    var thumb = div.find('img');
    var image_preview = div.find('.image-preview');

    button.on('click', function(e) {
      modal.addClass('attach');
      modal.one('click', '.select-gallery-image', function(e) {
        e.preventDefault();
        var url = $(e.target).data('url');
        input.val(url);
        thumb.attr('src',url);
        if(image_preview.attr('data-content')){
          var $content = $(image_preview.attr('data-content'));
          $content.find('img').attr('src', url);
          image_preview.attr('data-content', $content.html());
        }
        image_preview.removeClass('hidden');
      });
    });
  }

  attachGalleryImage('#image-gallery', '#action_page_featured_image', '#attached-featured_image');
  attachGalleryImage('#image-gallery', '#action_page_background_image', '#attached-background_image');
  attachGalleryImage('#image-gallery', '#action_page_og_image', '#attached-og_image');

  $('.tweet-target').each(function(i, target) {
    attachGalleryImage('#image-gallery', $(target).find('.image-input'), target);
  });

  $('#image-gallery').on('hidden.bs.modal', function(e) {
      $(e.target).removeClass('attach');
  });
});
