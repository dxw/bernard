module Bernard
  class Connection
    def initialize(client:)
      unless client.uri && client.uri.kind_of?(URI)
        raise(Bernard::ArgumentError, 'could not create a connection with URI')
      end

      @uri = client.uri
      @write_key = client.write_key
      @read_key = client.read_key
    end

    def post(payload)
      request = Net::HTTP::Post.new(uri.path)
      request['Authorization'] = write_key
      request['Content-Type'] = 'application/json'
      request.body = payload

      begin
        adapter.request(request)
      rescue Timeout::Error
        return false
      end
    end

    def adapter
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5
      http.read_timeout = 5
      http.use_ssl = true
      http
    end

  private
    attr_reader :uri, :write_key, :read_key
  end
end
