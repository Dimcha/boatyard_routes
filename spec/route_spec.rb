require 'spec_helper'

describe Route do
  describe 'route creation' do
    let(:route) { Route.new('A', 'B', 5) }

    it { expect(route.start).to eq('A') }
    it { expect(route.destination).to eq('B') }
    it { expect(route.distance).to eq(5) }
    it { expect(route.stops).to eq(1) }

    context 'default route connection' do
      it { expect(route.connection.distance).to eq(0) }
      it { expect(route.connection.stops).to eq(0) }
    end
  end

  describe 'connected routes creation' do
    let(:route1) { Route.new('A', 'B', 5) }
    let(:route2) { Route.new('B', 'C', 4) }

    before { route1.connect(route2) }

    it { expect(route1.distance).to eq(9) }
    it { expect(route1.stops).to eq(2) }
  end
end
