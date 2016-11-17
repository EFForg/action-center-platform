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

    $("#image-gallery").on("show.bs.modal", function() {
      $("#image-gallery").off("show.bs.modal");

      // Get list of all uploaded images and populate the gallery with refs to them
      $.getJSON('/admin/source_files', function (files) {
        $("#image-gallery .loading-indicator").hide();
        $.each(files, function(index, value) {
          // The template it's using seems to be...
          // app/views/admin/action_pages/_template_uploaded.html.erb
          $('#upload_files tbody').append(tmpl('template-uploaded', value));
        });

        height_changed();
      });
    });

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
