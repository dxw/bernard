module Bernard
  module Keen
    module Methods
      def tick(event)
        write(:tick, type: event, count: 1)
      end

      def count(event, value)
        write(:count, type: event, count: Integer(value))
      end

      def gauge(event, value)
        write(:gauge, type: event, value: Float(value))
      end

      def write(event, metadata)
        event = String(event).strip.downcase
        payload = metadata.merge!(default_params).to_json
        uri.path = "/3.0/projects/#{project_id}/events/#{event}"

        request = Net::HTTP::Post.new(uri.path)
        request['Authorization'] = write_key
        request['Content-Type'] = 'application/json'
        request.body = payload

        begin
          connection = Bernard::Connection.new(uri).call
          connection.request(request)
        rescue Timeout::Error
          return false
        end
      end

      private def default_params
        {
          application_name: application_name
        }
      end
    end
  end
end
