FuzzySetUtil = function(fuzzyset){
  this.fuzzyset = fuzzyset;
}

// given a term, find matches and return as a match object
FuzzySetUtil.prototype.match = function(term){
  var matches = this.fuzzyset.get(term);
  return _.map(matches, function(match){
    return {
      degree: match[0],
      term: match[1]
    }
  });
}

// given an array of terms, return all matches in a flat array of match objects
FuzzySetUtil.prototype.match_all = function(terms){
  var that = this;

  var staggered_match_map = [];
  _.each(terms, function(term){
    staggered_match_map.push(that.match(term))
  });
  return _.flatten(staggered_match_map);
}

// given any number of arrays of terms, ordered by priority, finds matches for each.  if the first has a match with max degree >= *threshold*, return that match.  otherwise, try the second, third, and so on.
FuzzySetUtil.prototype.find_best_match = function(terms_array, threshold){
  for(i in terms_array){
    var matches = this.match_all(terms_array[i])
    var max = _.max(matches, function(match){ return match.degree; });
    if(max.degree >= threshold){
      return max;
    }
  };
}

FuzzySetUtil.get_fuzzyset_from_select = function($select){
  var set = []
  $("option", $select).each(function(){
    set.push($(this).text().trim());
  });
  return FuzzySet(set);
}

FuzzySetUtil.new_from_select = function($select){
  return new this(this.get_fuzzyset_from_select($select));
}
