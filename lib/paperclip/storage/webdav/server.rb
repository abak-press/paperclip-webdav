require 'uri'
require 'curb'
require 'net/webdav/client'

module Paperclip
  module Storage
    module Webdav
      class Server
        extend Forwardable

        def_delegators :@client, :file_exists?, :get_file, :delete_file

        def initialize(credentials)
          @client = Net::Webdav::Client.new(credentials[:url],
                                            username: credentials[:username],
                                            password: credentials[:password])
        end

        def put_file(path, file)
          @client.put_file(path, file, true)
        end
      end
    end
  end
end
