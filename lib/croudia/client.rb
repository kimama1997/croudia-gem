require 'croudia/api/account'
require 'croudia/api/favorites'
require 'croudia/api/friendships'
require 'croudia/api/oauth'
require 'croudia/api/search'
require 'croudia/api/secret_mails'
require 'croudia/api/statuses'
require 'croudia/api/timelines'
require 'croudia/api/trends'
require 'croudia/api/users'
require 'croudia/api/utils'
require 'croudia/configurable'
require 'croudia/version'
require 'faraday'

module Croudia
  class Client
    include Croudia::API::Account
    include Croudia::API::Favorites
    include Croudia::API::Friendships
    include Croudia::API::OAuth
    include Croudia::API::Search
    include Croudia::API::SecretMails
    include Croudia::API::Statuses
    include Croudia::API::Timelines
    include Croudia::API::Trends
    include Croudia::API::Users
    include Croudia::API::Utils
    include Croudia::Configurable

    # Initialize a new Client object
    #
    # @param [Hash] options
    def initialize(options={})
      Croudia::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Croudia.instance_variable_get(:"@#{key}"))
      end
    end

    # Perform an HTTP DELETE request
    def delete(path, params={})
      request(:delete, path, params)
    end

    # Perform an HTTP GET request
    def get(path, params={})
      request(:get, path, params)
    end

    # Perform an HTTP POST request
    def post(path, params={})
      request(:post, path, params)
    end

    # Perform an HTTP PUT request
    def put(path, params={})
      request(:put, path, params)
    end

  private

    # @return [String] Response body
    def request(method, path, params={})
      connection.send(method.to_sym, path, params) do |request|
        request.headers[:authorization] = "Bearer #{@access_token}" if @access_token
      end.body
    end

    # Return a Faraday::Connection objet
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(builder: @middleware))
    end
  end
end
