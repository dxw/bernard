require 'spec_helper'

RSpec.describe Bernard::Keen::Methods do

  let(:client) do
    Bernard::Keen::Client.new(
      application_name: 'demo',
      project_id: '1234',
      write_key: 'WRITE_KEY',
    )
  end

  describe '#tick' do
    it 'writes a simple event into Keen' do
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/tick')

      client.tick(:on_fire)

      expect(WebMock)
        .to have_requested(:post, 'https://api.keen.io/3.0/projects/1234/events/tick')
        .with(body: { application_name: 'demo', type: 'on_fire', count: 1 })
    end
  end

  describe '#count' do
    it 'writes a simple event into Keen' do
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/count')

      client.count(:visitors, 10)

      expect(WebMock)
        .to have_requested(:post, 'https://api.keen.io/3.0/projects/1234/events/count')
        .with(body: { application_name: 'demo', type: 'visitors', count: 10 })
    end
  end

  describe '#gauge' do
    it 'writes a simple gauge event into Keen' do
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/gauge')

      client.gauge(:room_temperature, 42.1)

      expect(WebMock)
        .to have_requested(:post, 'https://api.keen.io/3.0/projects/1234/events/gauge')
        .with(body: { application_name: 'demo', type: 'room_temperature', value: 42.1 })
    end
  end
end
