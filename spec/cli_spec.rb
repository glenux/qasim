
require_relative 'spec_helper'

require 'qasim/cli'

describe Qasim::CLI do
        let(:cli) { Qasim::CLI.new }

        describe '.new' do
                it "can be created without arguments" do
                        assert_instance_of Qasim::CLI, cli
                end
        end

end
