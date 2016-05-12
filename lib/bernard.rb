require 'bernard/exception'
require 'bernard/schema'
require 'bernard/version'

require 'json'
require 'curb'

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
    schema = String(schema).strip
    uri = "#{BASE_URI}/projects/#{project_id}/events/#{schema}"

    request = Curl.post(uri) do |r|
      r.headers['Authorization'] = write_key
      r.headers['Content-Type'] = 'application/json'

      r.body_str = JSON.encode(metadata)
    end

    request.response_code == '200'
  end
end
