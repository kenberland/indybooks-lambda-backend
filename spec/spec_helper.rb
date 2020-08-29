Bundler.require(:default, ENV['INDY_ENV'])

root = File.expand_path("..", File.dirname(__FILE__))
$LOAD_PATH.unshift(root) unless $LOAD_PATH.include?(root)
