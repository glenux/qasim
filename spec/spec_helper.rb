#require 'mark'

require 'simplecov'
SimpleCov.start do
  add_filter { |src| src.filename.match(/_spec\.rb$/) }
end

require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'pry'

$LOAD_PATH.unshift('../lib')

