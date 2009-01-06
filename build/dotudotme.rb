YUI_COMPRESSOR_VERSION = '2.4.1'
YUI_COMPRESSOR_PATH = File.join(File.dirname(__FILE__), "yuicompressor-#{YUI_COMPRESSOR_VERSION}", "yuicompressor-#{YUI_COMPRESSOR_VERSION}") 

DEFAULT_INPUT           = 'dotudotme'
DEFAULT_TMPFILE_SUFFIX  = "_#{DEFAULT_INPUT}"
DEFAULT_MODULIZED       = "modulized#{DEFAULT_TMPFILE_SUFFIX}"
DEFAULT_MINIFIED        = "minified#{DEFAULT_TMPFILE_SUFFIX}"
DEFAULT_WITH_PROTOCOL   = "with_protocol#{DEFAULT_TMPFILE_SUFFIX}"
DEFAULT_OUTPUT          = 'bookmarklet'

namespace :bookmarklet do
  desc "Modulizes, minifies, and adds javascript: protocol to source js file. Requires yui-compressor"
  task :build, [:input, :output, :path_to_yui_compressor] do
    args.with_defaults(:input => DEFAULT_INPUT, :output => DEFAULT_OUTPUT, :path_to_yui_compressor => YUI_COMPRESSOR_PATH)
    modulize
    minify
    add_js_protocol(:output => DEFAULT_OUTPUT)
  end
  
  desc "Creates a modulized version of source js"
  task :modulize, [:input, :output] do
    args.with_defaults(:input => DEFAULT_INPUT, :output => DEFAULT_MODULIZED)
    out = File.open(args.output, 'w')
    out.write "(function(){\n"
    open(args.input) { |in| out.write in.read }
    out.write "\n})()"
    out.close
  end
  
  desc "Minifies source some js. Requires yui-compressor"
  task :minify, [:input, :output, :path_to_yui_compressor] do
    args.with_defaults(:input => DEFAULT_MODULIZED, :output => DEFAULT_MINIFIED, :path_to_yui_compressor => YUI_COMPRESSOR_PATH)
    exec "java -jar #{args.path_to_yui_compressor} -o #{args.output} #{args.input}"
  end
  
  desc "Adds 'javascript:' to some js"
  task :add_js_protocol, [:input, :output] do    
    args.with_defaults(:input => DEFAULT_MINIFIED, :output => DEFAULT_WITH_PROTOCOL)
    out = File.open(args.output, 'w')
    out.write "javascript:"
    open(args.input) { |in| out.write in.read }
    out.close
  end
end
