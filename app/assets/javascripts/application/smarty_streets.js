SmartyStreets = {
  // Given an address+zip, this will check that the address exists and
  // return a zip+4 and most importantly a latitude, longitude point for
  // querying the sunlight API to pull up relevant senators/ congress persons
  street_address: function(data) {
    var url = '/smarty_streets/street_address/';
    return $.get(url, data);
  }
};
