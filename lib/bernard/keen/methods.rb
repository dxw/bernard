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

      def splat(event, hash)
        write(:splat, type: event, value: hash)
      end

      private def write(event, metadata)
        event = String(event).downcase
        payload = metadata.merge!(default_params).to_json
        uri.path = "/3.0/projects/#{project_id}/events/#{event}"

        connection.post(payload)
      end

      private def default_params
        {
          application_name: application_name
        }
      end
    end
  end
end
