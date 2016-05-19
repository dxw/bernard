require 'spec_helper'

RSpec.describe Bernard::Keen::Client do
  before do
    Bernard::Keen::Client.configure do |client|
      client.config = {
        application_name: nil,
        project_id: nil,
        write_key: nil,
        read_key: nil,
      }
    end
  end

  describe '.initialize' do
    it 'sets the values provided' do
      client = Bernard::Keen::Client.new(
        application_name: 'demo',
        project_id: 'bar',
        write_key: 'baz',
        read_key: 'boo'
      )

      expect(client.application_name).to eq('demo')
      expect(client.project_id).to eq('bar')
      expect(client.write_key).to eq('baz')
      expect(client.read_key).to eq('boo')
    end

    context 'when there is default configuration' do
      it 'sets those values' do
        Bernard::Keen::Client.configure do |client|
          client.config = {
            application_name: 'green',
            project_id: 'red',
            write_key: 'blue',
            read_key: 'black'
          }
        end

        client = Bernard::Keen::Client.new

        expect(client.application_name).to eq('green')
        expect(client.project_id).to eq('red')
        expect(client.write_key).to eq('blue')
        expect(client.read_key).to eq('black')
      end
    end
  end

  describe '#uri' do
    it 'returns Keens API endpoint as a URI' do
      client = Bernard::Keen::Client.new
      expect(client.uri).to eq(URI('https://api.keen.io'))
    end
  end

  describe '#application_name=' do
    context 'when no value is received' do
      it 'raises an error' do
        client = Bernard::Keen::Client.new
        expect{ client.application_name = nil }
          .to raise_error(Bernard::ArgumentError, 'Missing application_name')
      end
    end
  end

  describe '#project_id=' do
    context 'when no value is received' do
      it 'raises an error' do
        client = Bernard::Keen::Client.new
        expect{ client.project_id = nil }
          .to raise_error(Bernard::ArgumentError, 'Missing project_id')
      end
    end
  end

  describe '#write_key=' do
    context 'when no value is received' do
      it 'raises an error' do
        client = Bernard::Keen::Client.new
        expect{ client.write_key = nil }
          .to raise_error(Bernard::ArgumentError, 'Missing write_key')
      end
    end
  end
end
