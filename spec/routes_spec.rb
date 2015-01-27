require 'spec_helper'

describe Routes do
  let(:routes) { Routes.new('AB5, BC4') }
  let(:routes1) { Routes.new('CD8, DC8') }
  let(:routes2) { Routes.new('AB5, BC4, CA1') }

  describe 'no such route' do
    it { expect(routes.find_route([])).to eq(NO_ROUTE) }
  end

  describe 'route distance' do
    it { expect(routes.find_route_distance('A', 'B')).to eq(5) }
    it { expect(routes.find_route_distance('A', 'B', 'C')).to eq(9) }

    context 'no such route' do
      it { expect(routes.find_route_distance([])).to eq(NO_ROUTE) }
      it { expect(routes.find_route_distance('A', 'B', 'A')).to eq(NO_ROUTE) }
    end
  end

  describe 'trips with max stops of 3' do
    it { expect(routes.trips_with_max_stops('C', 'C', 3).size).to eq(0) }
    it { expect(routes.trips_with_max_stops('A', 'C', 3).size).to eq(1) }
    it { expect(routes1.trips_with_max_stops('A', 'C', 3).size).to eq(0) }
    it { expect(routes2.trips_with_max_stops('C', 'C', 3).size).to eq(1) }

    context 'with round trips' do
      it { expect(routes2.trips_with_max_stops('C', 'C', 6).size).to eq(2) }
      it { expect(routes2.trips_with_max_stops('C', 'C', 9).size).to eq(3) }
    end
  end

  describe 'trips with max stops of 6' do
    it { expect(routes.trips_with_max_stops('A', 'C', 6).size).to eq(1) }
    it { expect(routes2.trips_with_max_stops('C', 'C', 6).size).to eq(2) }
  end

  describe 'trips with exact number of stops' do
    it { expect(routes.trips_with_stops('A', 'C', 2).size).to eq(1) }
    it { expect(routes.trips_with_stops('A', 'C', 3).size).to eq(0) }
    it { expect(routes2.trips_with_stops('A', 'A', 2).size).to eq(0) }
    it { expect(routes2.trips_with_stops('A', 'C', 2).size).to eq(1) }

    context 'visit same suburb twice' do
      it { expect(routes2.trips_with_stops('A', 'C', 5).size).to eq(1) }
    end
  end

  describe 'shortest distance' do
    it { expect(routes.distance_of_shortest_route('A', 'C')).to eq(9) }
    it { expect(routes1.distance_of_shortest_route('C', 'D')).to eq(8) }
    it { expect(routes1.distance_of_shortest_route('C', 'C')).to eq(16) }
    it { expect(routes2.distance_of_shortest_route('A', 'A')).to eq(10) }

    context 'no such route' do
      it { expect(routes.distance_of_shortest_route('A', 'D')).to eq(NO_ROUTE) }
      it { expect(routes1.distance_of_shortest_route('A', 'C')).to eq(NO_ROUTE) }
    end
  end

  describe 'trips with distance less than 10' do
    it { expect(routes.trips_with_less_distance('A', 'C', 10).size).to eq(1) }
    it { expect(routes1.trips_with_less_distance('C', 'C', 10).size).to eq(0) }
    it { expect(routes2.trips_with_less_distance('A', 'A', 10).size).to eq(0) }
    it { expect(routes2.trips_with_less_distance('A', 'C', 10).size).to eq(1) }
  end

  describe 'trips with distance less than 30' do
    it { expect(routes.trips_with_less_distance('A', 'C', 30).size).to eq(1) }
    it { expect(routes1.trips_with_less_distance('C', 'C', 30).size).to eq(1) }
    it { expect(routes2.trips_with_less_distance('A', 'A', 30).size).to eq(2) }
    it { expect(routes2.trips_with_less_distance('A', 'C', 30).size).to eq(3) }
  end
end
