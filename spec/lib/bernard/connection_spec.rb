require 'spec_helper'

RSpec.describe Bernard::Connection do
  describe '.new' do
    it 'returns an instance of Bernard::Connection' do
      client = double('client', uri: URI('foo'), write_key: '1', read_key: '2')

      connection = Bernard::Connection.new(client: client)

      expect(connection).to be_kind_of(Bernard::Connection)
    end

    context 'when the client does not receive a URI' do
      it 'goes boom' do
        client = double('client', uri: 'oops', write_key: '1', read_key: '2')

        expect{ Bernard::Connection.new(client: client) }
          .to raise_error(Bernard::ArgumentError)
      end
    end
  end

  describe '#adapter' do
    it 'returns a configured instance of Net::HTTP' do
      client = double('client', uri: URI('foo'), write_key: '1', read_key: '2')

      adapter = Bernard::Connection.new(client: client).adapter

      expect(adapter).to be_kind_of(Net::HTTP)
      expect(adapter.use_ssl?).to eq(true)
      expect(adapter.open_timeout).to eq(5)
      expect(adapter.read_timeout).to eq(5)
    end
  end

  describe '#post' do
    let(:client) do
      double('client',
        uri: URI('https://test.local/foo'),
        project_id: '1234',
        write_key: 'WRITE_KEY',
        read_key: '2'
      )
    end

    let(:connection) do
      Bernard::Connection.new(client: client)
    end

    it 'posts an event' do
      stub_request(:post, 'https://test.local/foo').to_timeout

      connection.post(count: 1)

      expect(WebMock).to have_requested(:post, 'https://test.local/foo')
    end

    it 'sets the correct HTTP headers on the request' do
      stub_request(:post, 'https://test.local/foo')

      connection.post(count: 1)

      expect(WebMock)
        .to have_requested(:post, 'https://test.local/foo')
        .with(headers: { 'Content-Type' => 'application/json',
                         'Authorization' => 'WRITE_KEY' })
    end

    context 'when a timeout occurs' do
      it 'fails silently if a timeout occurs during POST' do
        stub_request(:post, 'https://test.local/foo').to_timeout

        expect { connection.post(count: 1) }.to_not raise_error
      end
    end
  end
end
