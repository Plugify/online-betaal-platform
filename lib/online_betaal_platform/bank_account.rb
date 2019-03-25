module OnlineBetaalPlatform
  # Merchant bank account
  class BankAccount
    attr_reader :uid, :object, :created, :updated, :verified, :verification_url,
                :status, :account, :bank, :reference, :return_url, :notify_url,
                :is_default

    def initialize(attributes)
      @uid = attributes['uid']
      @object = attributes['object']
      @created = attributes['created']
      @updated = attributes['updated']
      @verified = attributes['verified']
      @verification_url = attributes['verification_url']
      @status = attributes['status']
      @account = attributes['account']
      @bank = attributes['bank']
      @reference = attributes['reference']
      @return_url = attributes['return_url']
      @notify_url = attributes['notify_url']
      @is_default = attributes['is_default']
    end

    def iban
      account['account_iban']
    end

    def payable?
      verified.present? && status == 'approved'
    end
  end
end
