require 'spec_helper'

RSpec.describe Bernard do
  describe '#publish' do
    it 'publishes an event' do
      bernard = Bernard.new
      allow(bernard).to receive(:project_id).and_return('1234')
      allow(bernard).to receive(:write_key).and_return('WRITE_KEY')
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/foo')

      bernard.publish(:foo, count: 1)

      expect(WebMock).to have_requested(:post, 'https://api.keen.io/3.0/projects/1234/events/foo')
    end

    it 'sets the correct HTTP headers on the request' do
      bernard = Bernard.new
      allow(bernard).to receive(:project_id).and_return('1234')
      allow(bernard).to receive(:write_key).and_return('WRITE_KEY')
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/bar')

      bernard.publish(:bar, count: 1)

      expect(WebMock)
        .to have_requested(:post, 'https://api.keen.io/3.0/projects/1234/events/bar')
        .with(headers: { 'Content-Type' => 'application/json',
                         'Authorization' => 'WRITE_KEY' })
    end

    it 'fails silently if a timeout occurs during POST' do
      bernard = Bernard.new
      allow(bernard).to receive(:project_id).and_return('1234')
      allow(bernard).to receive(:write_key).and_return('WRITE_KEY')
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/foo').to_timeout

      expect { bernard.publish(:foo, count: 1) }.to_not raise_error
    end
  end

  describe '#tick' do
    it 'publishes a simple event' do
      bernard = Bernard.new
      allow(bernard).to receive(:project_id).and_return('1234')
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/tick')

      bernard.tick(:on_fire)

      expect(WebMock)
        .to have_requested(:post, 'https://api.keen.io/3.0/projects/1234/events/tick')
        .with(body: { type: 'on_fire', count: 1 })
    end
  end

  describe '#gauge' do
    it 'publishes a simple gauge event' do
      bernard = Bernard.new
      allow(bernard).to receive(:project_id).and_return('1234')
      stub_request(:post, 'https://api.keen.io/3.0/projects/1234/events/gauge')

      bernard.gauge(:room_temperature, 42.1)

      expect(WebMock)
        .to have_requested(:post, 'https://api.keen.io/3.0/projects/1234/events/gauge')
        .with(body: { type: 'room_temperature', value: 42.1 })
    end
  end

  describe '#write_key=' do
    it 'sets write_key with the passed in value' do
      valid_key = 'a' * 192

      b = Bernard.new
      b.write_key = valid_key

      expect(b.write_key).to eql valid_key
    end

    it 'throws a Bernard::Exception if it is not formatted correctly' do
      b = Bernard.new

      expect { b.write_key = 'BAD_KEY' }.to raise_error(Bernard::Exception)
    end
  end

  describe '#project_id=' do
    it 'sets project_id with the passed in value' do
      valid_project_id = '123456789abcdef012345678'

      b = Bernard.new
      b.project_id = valid_project_id

      expect(b.project_id).to eql valid_project_id
    end

    it 'throws a Bernard::Exception if it is not formatted correctly' do
      b = Bernard.new

      expect { b.project_id = 'BAD_KEY' }.to raise_error(Bernard::Exception)
    end
  end
end
