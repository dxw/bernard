require 'bernard/connection'
require 'bernard/keen/methods'

module Bernard
  module Keen
    class Client
      class << self
        attr_reader :config

        def configure
          yield self
        end

        def config=(args)
          @config = {
            uri: args[:uri],
            project_id: args[:project_id],
            write_key: args[:write_key],
            read_key: args[:read_key]
          }
        end
      end

      include Bernard::Keen::Methods

      attr_reader :uri, :project_id, :write_key, :read_key

      def initialize(args = {})
        config = config_from(args)

        @uri = config.fetch(:uri, nil)
        @project_id = config.fetch(:project_id, nil)
        @write_key = config.fetch(:write_key, nil)
        @read_key = config.fetch(:read_key, nil)
      end

      private def config_from(args)
        if !args.empty?
          args
        elsif Bernard::Keen::Client.config
          Bernard::Keen::Client.config
        else
          {}
        end
      end

      def uri=(value)
        raise(Bernard::ArgumentError, 'Missing URI') unless value
        raise(Bernard::ArgumentError, 'Invalid URI') unless value.kind_of?(URI)
        @uri = value
      end

      def project_id=(value)
        raise(Bernard::ArgumentError, 'Missing project_id') unless value
        @project_id = value
      end

      def write_key=(value)
        raise(Bernard::ArgumentError, 'Missing write_key') unless value
        @write_key = value
      end

      def read_key=(value)
        @read_key = value
      end
    end
  end
end
