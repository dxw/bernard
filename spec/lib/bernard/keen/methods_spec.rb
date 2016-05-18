require 'spec_helper'

RSpec.describe Bernard::Keen::Methods do

  let(:client) do
    Bernard::Keen::Client.new(
      uri: URI('http://test.local'),
      application_name: 'demo',
      project_id: '1234',
      write_key: 'WRITE_KEY',
    )
  end

  describe '#tick' do
    it 'writes a simple event into Keen' do
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/tick')

      client.tick(:on_fire)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/tick')
        .with(body: { application_name: 'demo', type: 'on_fire', count: 1 })
    end
  end

  describe '#count' do
    it 'writes a simple event into Keen' do
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/count')

      client.count(:visitors, 10)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/count')
        .with(body: { application_name: 'demo', type: 'visitors', count: 10 })
    end
  end

  describe '#gauge' do
    it 'writes a simple gauge event into Keen' do
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/gauge')

      client.gauge(:room_temperature, 42.1)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/gauge')
        .with(body: { application_name: 'demo', type: 'room_temperature', value: 42.1 })
    end
  end

  describe '#write' do
    it 'publishes an event' do
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/foo').to_timeout

      client.write(:foo, count: 1)

      expect(WebMock).to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/foo')
    end

    it 'sets the correct HTTP headers on the request' do
      stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/bar')

      client.write(:bar, count: 1)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local:80/3.0/projects/1234/events/bar')
        .with(headers: { 'Content-Type' => 'application/json',
                         'Authorization' => 'WRITE_KEY' })
    end

    context 'when a timeout occurs' do
      it 'fails silently if a timeout occurs during POST' do
        stub_request(:post, 'https://test.local:80/3.0/projects/1234/events/foo').to_timeout

        expect { client.write(:foo, count: 1) }.to_not raise_error
      end
    end
  end
end
