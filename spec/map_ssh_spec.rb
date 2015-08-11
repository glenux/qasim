
require_relative 'spec_helper'
require 'minitest/spec'
require 'qasim/map/generic'
require 'qasim/map/ssh'

describe Qasim::Map::Ssh do
  describe 'parameters' do
    it 'contains at least all generic parameters' do
      expected = Qasim::Map::Generic.parameters.keys
      current = Qasim::Map::Ssh.parameters.keys

      keys = (expected & current)
      assert (keys.size >= expected.size)
    end
  end
end
