
require_relative 'spec_helper'
require 'minitest'
require 'pry'

require 'qasim/cli'

describe Qasim::Cli do
  let(:cli) { Qasim::Cli.new }

  describe 'new' do
    it "can be created without arguments" do
      skip "Later" #assert_instance_of Qasim::Cli, cli
    end
  end

  describe 'list' do
    it "must exist" do
      assert_respond_to cli, :list
    end

    it "must show existing maps" do
      skip "Add map. List maps. Verify added map exists"
    end
  end

  describe 'add' do
    it "must exist" do
      skip "assert_respond_to cli, :add"
    end
  end

  describe 'del' do
    it "must exist" do
      skip "assert_respond_to cli, :del"
    end
  end

end
