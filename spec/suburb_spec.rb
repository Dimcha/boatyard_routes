require 'spec_helper'

describe Suburb do
  describe 'suburb creation' do
    let(:suburb) { Suburb.new('A') }

    it { expect(suburb.name).to eq('A') }
  end
end
