require 'spec_helper'

RSpec.describe Bernard::Connection do
  describe '.new' do
    it 'returns an instance of Bernard::Connection' do
      uri = URI.parse('www.example.com')
      expect(Bernard::Connection.new(uri)).to be_kind_of(Bernard::Connection)
    end

    it 'takes a URI as a single parameter' do
      uri = URI.parse('www.example.com')
      expect{ Bernard::Connection.new(uri) }.not_to raise_error
    end

    context 'when it does not receive a URI' do
      it 'goes boom' do
        expect{ Bernard::Connection.new('foobar') }
          .to raise_error(Bernard::ArgumentError)
      end
    end
  end

  describe '#call' do
    it 'returns a valid instance of Net::HTTP' do
      uri = URI.parse('www.example.com')

      connection = Bernard::Connection.new(uri).call

      expect(connection).to be_kind_of(Net::HTTP)
      expect(connection.use_ssl?).to eq(true)
      expect(connection.open_timeout).to eq(5)
      expect(connection.read_timeout).to eq(5)
    end
  end
end
