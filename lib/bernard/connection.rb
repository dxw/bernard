module Bernard
  class Connection
    def initialize(uri)
      unless uri && uri.kind_of?(URI)
        raise(Bernard::ArgumentError, 'could not parse URI')
      end
      @uri = uri
    end

    def call
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5
      http.read_timeout = 5
      http.use_ssl = true
      http
    end

  private
    attr_reader :uri
  end
end
