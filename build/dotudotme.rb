# TODO: intelligentally replace double-quotes with single-quotes

YUI_COMPRESSOR_VERSION = '2.4.1'
YUI_COMPRESSOR_PATH = File.join(
    File.dirname(__FILE__), 
    "yuicompressor-#{YUI_COMPRESSOR_VERSION}", 
    "build", 
    "yuicompressor-#{YUI_COMPRESSOR_VERSION}"
) 

SRC_PATH                = File.join(File.dirname(__FILE__), '..', 'src')
DEFAULT_INPUT           = 'dotudotme.js'
DEFAULT_TMPFILE_SUFFIX  = "_#{DEFAULT_INPUT}"
DEFAULT_MODULIZED       = "modulized#{DEFAULT_TMPFILE_SUFFIX}"
DEFAULT_MINIFIED        = "minified#{DEFAULT_TMPFILE_SUFFIX}"
DEFAULT_WITH_PROTOCOL   = "with_protocol#{DEFAULT_TMPFILE_SUFFIX}"
DEFAULT_OUTPUT          = 'bookmarklet.js'

namespace :bookmarklet do
  # FIXME: As of Rake 0.8.3 you cannot pass pass parameters to a prerequisite
  # So :minify will have to output DEFAULT_OUTPUT whether it's called from :build or as standalone  
  # task :build, [:input, :output, :path_to_yui_compressor] => [:modulize, :add_js_protocol, [:minify, DEFAULT_OUTPUT]]
  desc "Modulizes, minifies, and adds javascript: protocol to source js file. Requires yui-compressor"
  task :build => [:modulize, :add_js_protocol, :minify]  
  
  desc "Creates a modulized version of source js"
  task :modulize, [:input, :output] do |t, args|
    args.with_defaults(
        :input => File.join(SRC_PATH, DEFAULT_INPUT), 
        :output => File.join(SRC_PATH, DEFAULT_MODULIZED)
    )
    out = File.open(args.output, 'w')
    out.write "(function(){\n"
    open(args.input) { |input| out.write input.read }
    out.write "\n})();"
    out.close
  end
  
  desc "Adds 'javascript:' to some js"
  task :add_js_protocol, [:input, :output] do |t, args|
    args.with_defaults(
        :input => File.join(SRC_PATH, DEFAULT_MODULIZED), 
        :output => File.join(SRC_PATH, DEFAULT_WITH_PROTOCOL)
    )
    out = File.open(args.output, 'w')
    out.write "javascript:"
    open(args.input) { |input| out.write input.read }
    out.close
  end
    
  desc "Minifies source some js. Requires yui-compressor"
  task :minify, [:input, :output, :path_to_yui_compressor] do |t, args|
    args.with_defaults(
        :input => File.join(SRC_PATH, DEFAULT_WITH_PROTOCOL), 
        :output => DEFAULT_OUTPUT, 
        :path_to_yui_compressor => YUI_COMPRESSOR_PATH
    )
    p args.output
    exec "java -jar #{args.path_to_yui_compressor}.jar -o #{args.output} #{args.input}"
  end
end
