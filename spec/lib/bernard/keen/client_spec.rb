require 'spec_helper'

RSpec.describe Bernard::Keen::Client do
  before do
    Bernard::Keen::Client.configure do |client|
      client.config = {
        uri: nil,
        project_id: nil,
        write_key: nil,
        read_key: nil,
      }
    end
  end

  describe '.initialize' do
    let(:uri) { URI('foo') }

    it 'sets the values provided' do
      client = Bernard::Keen::Client.new(
        uri: uri,
        project_id: 'bar',
        write_key: 'baz',
        read_key: 'boo'
      )

      expect(client.uri).to eq(uri)
      expect(client.project_id).to eq('bar')
      expect(client.write_key).to eq('baz')
      expect(client.read_key).to eq('boo')
    end

    context 'when there is default configuration' do
      it 'sets those values' do
        Bernard::Keen::Client.configure do |client|
          client.config = {
            uri: uri,
            project_id: 'red',
            write_key: 'blue',
            read_key: 'black'
          }
        end

        client = Bernard::Keen::Client.new

        expect(client.uri).to eq(uri)
        expect(client.project_id).to eq('red')
        expect(client.write_key).to eq('blue')
        expect(client.read_key).to eq('black')
      end
    end
  end

  describe '#uri=' do
    context 'when the value is not a URI' do
      it 'raises an error' do
        client = Bernard::Keen::Client.new
        expect{ client.uri = 'foobar' }
          .to raise_error(Bernard::ArgumentError, 'Invalid URI')
      end
    end

    context 'when no value is received' do
      it 'raises an error' do
        client = Bernard::Keen::Client.new
        expect{ client.uri = nil }
          .to raise_error(Bernard::ArgumentError, 'Missing URI')
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

  describe '#tick' do
    it 'writes a simple event into Keen' do
      client = Bernard::Keen::Client.new(
        uri: URI('http://test.local'),
        project_id: '1234'
      )
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/tick')

      client.tick(:on_fire)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/tick')
        .with(body: { type: 'on_fire', count: 1 })
    end
  end

  describe '#gauge' do
    it 'writes a simple gauge event into Keen' do
      client = Bernard::Keen::Client.new(
        uri: URI('http://test.local'),
        project_id: '1234'
      )
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/gauge')

      client.gauge(:room_temperature, 42.1)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/gauge')
        .with(body: { type: 'room_temperature', value: 42.1 })
    end
  end

  describe '#write' do
    it 'publishes an event' do
      client = Bernard::Keen::Client.new(
        uri: URI('http://test.local'),
        project_id: '1234',
      )
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/foo').to_timeout

      client.write(:foo, count: 1)

      expect(WebMock).to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/foo')
    end

    it 'sets the correct HTTP headers on the request' do
      client = Bernard::Keen::Client.new(
        uri: URI('http://test.local'),
        project_id: '1234',
        write_key: 'WRITE_KEY',
      )
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/bar')

      client.write(:bar, count: 1)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/bar')
        .with(headers: { 'Content-Type' => 'application/json',
                         'Authorization' => 'WRITE_KEY' })
    end

    context 'when a timeout occurs' do
      it 'fails silently if a timeout occurs during POST' do
        client = Bernard::Keen::Client.new(
          uri: URI('http://test.local'),
          project_id: '1234',
          write_key: 'WRITE_KEY'
        )
        stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/foo').to_timeout

        expect { client.write(:foo, count: 1) }.to_not raise_error
      end
    end
  end
end
