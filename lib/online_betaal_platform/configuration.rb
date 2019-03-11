module OnlineBetaalPlatform
  class Configuration
    attr_writer :live_mode, :api_user_key, :notify_url, :bank_account_redirect_url

    def initialize
      # This gem initializes by default in sandbox mode
      @live_mode = false
      @api_user_key = nil
      @notify_url = nil
      @bank_account_redirect_url = nil
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

    def notify_url
      raise "Online Betaal Platform notify_url is missing!" unless @notify_url
      @notify_url
    end

    def bank_account_redirect_url
      raise "Online Betaal Platform bank_account_redirect_url is missing!" unless @bank_account_redirect_url
      @bank_account_redirect_url
    end

  end
end
