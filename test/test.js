TEST_VALUES = [
  ['localhost:3000', false],
  ['de.wikipedia.org/foo', 'en.wikipedia.org/foo', 'cs.wikipedia.org/foo', 'en.wikipedia.org/foo'],
  ['amazon.de/bar', 'amazon.co.uk/bar', 'amazon.com/bar', 'amazon.cz/bar', 'amazon.co.uk/bar'], 
  ['google.de/zip', 'google.co.uk/zip', 'google.com/zip', 'google.cz/zip', 'google.co.uk/zip'], 
  ['darpa.mil', false], 
  ['blah.gov', false], 
  ['blah.gov.uk', false], 
  ['foo.museum', false], 
  ['www.google.cz', 'www.google.co.uk'],
  ['www.google.cz/?xxx', 'www.google.co.uk/?xxx'],
  ['blah.co.jp', 'blah.co.uk', 'blah.com', 'blah.cz', 'blah.co.uk'],
  ['some.horrid.multilevel.thing.es:99/aycarumba', 'some.horrid.multilevel.thing.co.uk:99/aycarumba', 'some.horrid.multilevel.thing.com:99/aycarumba']
];

function test() {
  if (('console' in window) || ('firebug' in console)) {
    console.clear();
    var failures = 0;
    for(var i = 0; i < TEST_VALUES.length; i++){
      var test_cycle = TEST_VALUES[i];  
      var cycle_size = test_cycle.length;
      for(var j = 0; j < cycle_size - 1; j++) {
        var url = test_cycle[j];
        var new_url = get_new_url(url);
        var expected_url = test_cycle[j + 1];
        if(new_url != expected_url) {
          console.error("FAILED: With %s, got %s, expected %s", url, new_url, expected_url);
        } else {
          console.info("PASSED: With %s, got %s, expected %s", url, new_url, expected_url);
        }
      }
    }
    if(failures > 0){
      document.getElementById('output').innerHTML = ('There were ' + failures + ' test failures.');
    } else {
      document.getElementById('output').innerHTML = ('All the tests passed!');
    }
  } else {
    document.getElementById('output').innerHTML = ('You must have <a href="http://www.getfirebug.com">Firebug</a> to run the test suite.');
  }
}
