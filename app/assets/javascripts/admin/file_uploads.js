$(function () {
  var bucket = $('#fileupload').data('amazon_bucket');
  var amazonRegion = $('#fileupload').data('amazon_region');
  var bucketUrl = 'https://' + bucket + '.s3-' + amazonRegion + '.amazonaws.com/';

  // If we can find the #fileupload form in DOM
  if ($('#fileupload').length > 0) {

    // point the 'action' attribute to the bucket url
    $('#fileupload').attr('action', bucketUrl);

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
      dataType: 'xml',
      sequentialUploads: true
    });

    var gallery = $("#image-gallery .gallery");
    $("#image-gallery form.gallery-filter").on("submit", function(e) {
      e.preventDefault();

      $.ajax({
        url: this.action + "?" + $(this).serialize(),

        success: function(response) {
          gallery.html(response);
        }
      });
    });

    $("#image-gallery table[role=presentation] form.delete").on("submit", function(e) {
      e.preventDefault();

      var row = $(this).parents("tr");
      $.ajax({
        url: e.target.action,
        method: "post",
        data: { _method: "delete" },
        success: function() {
          row.remove();
        }
      });
    });

    $("#image-gallery form.gallery-filter input[type=text]").val('');
  }
});

// used by the jQuery File Upload
var fileUploadErrors = {
  maxFileSize: 'File is too big',
  minFileSize: 'File is too small',
  acceptFileTypes: 'Filetype not allowed',
  maxNumberOfFiles: 'Max number of files exceeded',
  uploadedBytes: 'Uploaded bytes exceed file size',
  emptyResult: 'Empty file upload result'
};

_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};
