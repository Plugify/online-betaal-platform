require 'net/http'
require 'uri'
require 'rack'

module OnlineBetaalPlatform
  # API Request
  class Request
    def self.post(endpoint, data)
      uri = URI.parse(OnlineBetaalPlatform.configuration.api_root_url + endpoint)
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(OnlineBetaalPlatform.configuration.api_user_key, "")
      request.body = Rack::Utils.build_nested_query(data)

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      # Raise any API errors
      raise(StandardError, Oj.load(response.body)) if response.code != '200'

      # Return response
      Oj.load(response.body)
    end

    def self.get(endpoint, page = 1, per_page = 10, filters = {})
      uri = URI.parse(OnlineBetaalPlatform.configuration.api_root_url + endpoint)
      if filters.present?
        filters_hash = filters.inject({}) do |h, (key, val)|
          h["filter[#{key}]"] = val
          h
        end
        filters_hash.merge!({ perpage: per_page, page: page })
        uri.query = URI.encode_www_form(filters_hash)
      else
        uri.query = URI.encode_www_form(perpage: per_page, page: page)
      end
      request = Net::HTTP::Get.new(uri)
      request.basic_auth(OnlineBetaalPlatform.configuration.api_user_key, "")

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      # Raise any API errors
      raise(StandardError, Oj.load(response.body)) if response.code != '200'

      # Return response
      Oj.load(response.body)
    end

  end
end

