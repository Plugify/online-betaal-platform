module OnlineBetaalPlatform
  class Configuration
    attr_writer :live_mode, :api_user_key, :merchant_notify_url

    def initialize
      # This gem initializes by default in sandbox mode
      @live_mode = false
      @api_user_key = nil
      @merchant_notify_url = nil
    end

    def live_mode
      @live_mode
    end

    def api_root_url
      @api_root_url = "https://api#{self.live_mode ? '' : '-sandbox'}.onlinebetaalplatform.nl/v1"
    end


    def http_auth
      @http_auth = HTTP.basic_auth(user: self.api_user_key, pass: '')
    end

    def api_user_key
      raise "Online Betaal Platform api user_key is missing!" unless @api_user_key
      @api_user_key
    end

    def merchant_notify_url
      raise "Online Betaal Platform merchant_notify_url is missing!" unless @merchant_notify_url
      @merchant_notify_url
    end
  end
end
