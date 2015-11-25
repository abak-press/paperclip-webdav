require 'uri'
require 'curb'
require "net/webdav/client"

module Paperclip
  module Storage
    module Webdav
      class Server
        class ConnectionFailedError < Curl::Err::ConnectionFailedError
          def initialize(host)
            super("Could not connect to host: #{host}")
          end
        end

        def initialize credentials
          @client = Net::Webdav::Client.new(credentials[:url], username: credentials[:username], password: credentials[:password])
        end

        def file_exists? path
          with_errors_handling {@client.file_exists?(path) }
        end

        def get_file remote_file_path, local_file_path
          with_errors_handling { @client.get_file(remote_file_path, local_file_path) }
        end

        def put_file path, file
          with_errors_handling { @client.put_file(path, file, true) }
        end

        def delete_file path
          with_errors_handling { @client.delete_file(path) }
        end

        private

        def with_errors_handling
          yield
        rescue Curl::Err::ConnectionFailedError
          raise ConnectionFailedError.new(@client.host)
        end
      end
    end
  end
end
