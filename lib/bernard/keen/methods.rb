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

      def splat(events)
        multiple_write(:splat, events)
      end

      private def write(event, metadata)
        event = String(event).downcase
        payload = metadata.merge!(default_params).to_json
        uri.path = "/#{api_version}/projects/#{project_id}/events/#{event}"

        connection.post(payload)
      end

      private def multiple_write(event, events)
        uri.path = "/#{api_version}/projects/#{project_id}/events"
        payload = { event => events }.to_json

        connection.post(payload)
      end

      private def default_params
        { application_name: application_name }
      end
    end
  end
end
