SmartyStreets = {
  street_address: function(data) {
    var url = '/smarty_streets/street_address/';
    return $.get(url, data);
  }
};
