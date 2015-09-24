/*
 * s3-cors-file-upload
 * http://github.com/fullbridge-batkins/s3_cors_fileupload
 *
 * Copyright 2013, Ben Atkins
 * http://batkins.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

// This global variable will hold s3 file credentials for files until it's time to submit them
var s3_upload_hash = {};

$(function() {
  // hit the controller for info when the file comes in
  $('#fileupload').bind('fileuploadadd', function (e, data) {
      var content_type = data.files[0].type;
      var file_name = data.files[0].name;

      $.getJSON('/source_files/generate_key.json', {filename: file_name}, function(data) {
        // Now that we have our data, we add it to the global s3_upload_hash so that it can be
        // accessed (in the fileuploadsubmit callback) prior to being submitted
        s3_upload_hash[file_name] = {
          key: data.key,
          content_type: content_type
        };
      });
  });

  // this gets triggered right before a file is about to be sent (and have their form action submitted)
  $('#fileupload').bind('fileuploadsubmit', function (e, data) {
      var file_name = data.files[0].name;
      // transfer the data from the upload-template .form hidden fields to the real form's hidden fields
      var form = $('#fileupload');
      form.find('input[name=key]').val(s3_upload_hash[file_name]['key']);
      form.find('input[name=Content-Type]').val(s3_upload_hash[file_name]['content_type']);
      delete s3_upload_hash[file_name];
  });

  $('#fileupload').bind('fileuploaddone', function (e, data) {
      // the response will be XML, and can be accessed by calling `data.result`
      //
      // Here is an example of what the XML will look like coming back from S3:
      //  <PostResponse>
      //    <Location>https://bucket-name.s3.amazonaws.com/uploads%2F3ducks.jpg</Location>
      //    <Bucket>bucket-name</Bucket>
      //    <Key>uploads/3ducks.jpg</Key>
      //    <ETag>"c7902ef289687931f34f92b65afda320"</ETag>
      //  </PostResponse>

      $.post('/source_files.json',
          {
            'source_file[url]': $(data.result).find('Location').text(),
            'source_file[bucket]': $(data.result).find('Bucket').text(),
            'source_file[key]': $(data.result).find('Key').text(),
            authenticity_token: $('meta[name=csrf-token]').attr('content')
          },
          function(data) {
            $('#upload_files tbody').prepend(tmpl('template-uploaded', data));
          },
          'json'
      );
   });

   $('#fileupload').bind('fileuploadcompleted', function (e, data) {
      // remove the downloaded templates, since in the above function we put our own custom 'template-uploaded' onto the list instead
      data.context.remove();
   });

   $('#fileupload').bind('fileuploaddestroyed', function (e, data) {
      if (!data.url) // sometimes this callback seems to get triggered a couple times, and has null data after the first time
        return null;

      // remove the table row containing the source file information from the page
      $('#source_file_' + data.object_id).remove();
   });

});

// used for displaying approximate file size on the file listing index.
// functionality mimics what the jQuery-File-Upload script does.
function formatFileSize(bytes) {
  if (typeof bytes !== 'number')
    return '';
  else if (bytes >= 1000000000)
    return (bytes / 1000000000).toFixed(2) + ' GB';
  else if (bytes >= 1000000)
    return (bytes / 1000000).toFixed(2) + ' MB';
  else
    return (bytes / 1000).toFixed(2) + ' KB';
}
