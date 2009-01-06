MAPPINGS = [['co', 'uk'], ['com'], ['cz']];
LANGUAGE_CODES = ['en', 'cs']; // for wikipedia only

URL_PARSER = /^((?:http[s]?|ftp):\/?\/?)?([^:\/\s]+)(.*)$/i;
U_LEFT = 1;
DOMAIN = 2;
U_RIGHT = 3;

WIKIPEDIA = /^([a-z]{2})(\.wikipedia\..*)/i
W_LANG = 1;
W_RIGHT = 2;

TLDS_TO_IGNORE = [
  'gov', 'org', 'edu', 'mil', 
  'info', 'coop', 'jobs', 
  'mobi', 'museum', 'name', 
  'aero', 'net', 'tel', 'travel',
  'arpa', 'pro', 'asia', 'localhost'
];
IGNORE = new RegExp('.(' + TLDS_TO_IGNORE.join('|') + ')(\.[a-z]{2})?$', 'i');

function get_new_url(href) {
  var parsed_href = URL_PARSER.exec(href);
  if(!parsed_href){
    return false;
  }
  
  var domain = parsed_href[DOMAIN];
  var new_domain; 
  
  if(domain.match(/localhost(?::[0-9]+)?/, i)){
    return false;
  }
  
  // wikipedia
  var wikipedia;
  if(wikipedia = WIKIPEDIA.exec(domain)) {
    var new_lang = LANGUAGE_CODES.first();
    for(var i = 0; i < LANGUAGE_CODES.length; i++){
      if(LANGUAGE_CODES[i] == wikipedia[W_LANG]) {
        new_lang = LANGUAGE_CODES.next(i);
      }
    }
    new_domain = new_lang + (wikipedia[W_RIGHT] || '');
    return (parsed_href[U_LEFT] || '') + new_domain + (parsed_href[U_RIGHT] || '');
  } else {
    // ignore some tld's
    if(IGNORE.exec(domain)){
      return false;
    }
  }
  
  // now the only tricky bit is to manage any secondary-level domain element e.g. '.co'
  var new_tld = MAPPINGS.first();
  for(var i = 0; i < MAPPINGS.length; i++){
    var mapping = MAPPINGS[i];
    var regexp = new RegExp('.(' + mapping.join(').(') + ')', 'i')
    if(regexp.exec(domain)){
      new_tld = MAPPINGS.next(i);
    }
  }
  new_domain = domain.replace(/((?:\.co)?(?:\.[a-z]{2,}))$/i, '.' + new_tld.join('.'));
  
  return (parsed_href[U_LEFT] || '') + new_domain + (parsed_href[U_RIGHT] || '');
} 

Array.prototype.next = function(index) {
  return this[(parseInt(index) + 1) % this.length];
}
  
Array.prototype.first = function() {
  return this[0];
}

var new_url;
if(new_url = get_new_url(window.location.href)) {
  window.location.href = new_url;
}
