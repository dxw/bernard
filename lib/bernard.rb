require 'bernard/exception'
require 'bernard/schema'
require 'bernard/version'

require 'json'
require 'net/https'
require 'uri'

class Bernard
  BASE_URI = 'https://api.keen.io/3.0'

  attr_reader :project_id, :write_key

  def project_id=(id)
    project_id = String(id).strip.downcase
    raise Bernard::Exception unless !!(project_id =~ /\A[0-9a-f]{24}\Z/)

    @project_id = project_id
  end

  def write_key=(key)
    write_key = String(key).strip.downcase
    raise Bernard::Exception unless !!(write_key =~ /\A[0-9a-f]{192}\Z/)

    @write_key = write_key
  end

  def publish(schema, metadata)
    schema = String(schema).strip.downcase

    uri = URI.parse(BASE_URI)

    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5
    http.read_timeout = 5
    http.use_ssl = true

    request = Net::HTTP::Post.new("/projects/#{project_id}/events/#{schema}")
    request['Authorization'] = write_key
    request['Content-Type'] = 'application/json'
    request.body = metadata.to_json

    response = http.request(request)
    response.code == '200'
  end
end
