
//<![CDATA[
  $(function () {
    if($('#fileupload').length > 0) {
      $('#fileupload').attr('action', 'https://actioncenter.s3-us-west-1.amazonaws.com/');
      // Initialize the jQuery File Upload widget:
      $('#fileupload').fileupload({
        dataType: 'xml',
        sequentialUploads: true
      });

      // Load existing files:
      $.getJSON('/source_files', function (files) {
        $.each(files, function(index, value) {
          $('#upload_files tbody').append(tmpl('template-uploaded', value));
        });
      });
    }
    height_changed();
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
//]]>
