
require_relative 'spec_helper'
require 'minitest/spec'
require 'qasim/map'
require 'securerandom'

class Qasim::Map::Fake < Qasim::Map::Generic
  def self.handles
    [:fake]
  end
end

describe Qasim::Map do
  describe 'env_substitute' do# {{{
    it "returns a normal string unchanged" do
      str = "5cb0c49325df2d526116ef7b49eb7329"
      assert_equal Qasim::Map.env_substitute(str), str
    end

    it "replaces a ${variable} with its value from environment" do
      str = "SOMETHING = ${HOME}"
      ref = "SOMETHING = #{ENV['HOME']}"
      assert_equal ref, Qasim::Map.env_substitute(str)
    end

    it "replaces a $variable with its value from environment" do
      str = "SOMETHING = $HOME"
      ref = "SOMETHING = #{ENV['HOME']}"
      assert_equal ref, Qasim::Map.env_substitute(str)
    end

    it "does not replace original string" do
      str = "SOMETHING = $HOME"
      res = "SOMETHING = $HOME"
      Qasim::Map.env_substitute(str)
      assert_equal res, str
    end

    it "works recursively" do
      ENV['QASIM_MAP_TEST1']='QASIM_MAP_TEST2'
      ENV['QASIM_MAP_TEST2']='OK'
      str = "SOMETHING = ${$QASIM_MAP_TEST1}"
      ref = "SOMETHING = OK"
      assert_equal ref, Qasim::Map.env_substitute(str)
    end
  end# }}}

  describe 'class_for' do
    it 'must return a class for given type' do
      expected = Qasim::Map::Fake
      result = Qasim::Map.class_for 'fake'

      assert_equal expected, result
    end

    it 'must return nil when no type found' do
      random_string = SecureRandom.hex
      expected = nil
      result = Qasim::Map.class_for random_string

      assert_equal expected, result
    end
  end

  describe 'from_file' do

  end
end

