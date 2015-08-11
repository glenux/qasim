
require_relative 'spec_helper'
require 'qasim/map/webdav'

describe Qasim::Map::Webdav do
  describe 'parameters' do
    it 'contains at least all generic parameters' do
      expected = Qasim::Map::Generic.parameters.keys
      current = Qasim::Map::Webdav.parameters.keys

      keys = (expected & current)
      assert (keys.size >= expected.size)
    end
  end
end

