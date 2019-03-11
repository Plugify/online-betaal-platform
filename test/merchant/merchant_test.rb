require './test/test_helper'

class MerchantTest < Minitest::Test
  def test_exists
    assert OnlineBetaalPlatform::Merchant
  end

  def test_it_gets_a_single_merchant
    VCR.use_cassette('one_merchant') do
      merchant = OnlineBetaalPlatform::Merchant.find('mer_09c609a961db')
      assert_equal OnlineBetaalPlatform::Merchant, merchant.class

      assert_equal false, merchant.livemode
      assert_equal 'mer_09c609a961db', merchant.uid
      assert_equal 'merchant', merchant.object
      assert_equal 1551713009, merchant.created
      assert_equal 1552399338, merchant.updated
      assert_equal 'live', merchant.status
      assert_equal(
        {
          'level' => 200,
          'status' => 'pending',
          'requirements' => [
            {
              'type' => 'bank_account.verification.required',
              'status' => 'pending',
              'object_uid' => 'bnk_2dc0825cea81',
              'object_type' => 'bank_account',
              'object_url' => 'https://api-sandbox.onlinebetaalplatform.nl/v1/merchants/mer_09c609a961db/bank_accounts/bnk_2dc0825cea81',
              'object_redirect_url' => 'https://sandbox.onlinebetaalplatform.nl/nl/plugify/merchants/mer_09c609a961db/verificatie/bankgegevens/bnk_2dc0825cea81/410bb2c420ea20f4c4520aa5f3603e4384aaab7d'
            }
          ]
        }, merchant.compliance
      )
      assert_equal 'open', merchant.type
      assert_equal '', merchant.coc_nr
      assert_equal 'Plugify', merchant.name
      assert_equal [], merchant.addresses
      assert_equal [], merchant.trading_names
      assert_equal [], merchant.contacts
      assert_equal [], merchant.profiles
      assert_equal [], merchant.payment_methods
      assert_nil merchant.phone
      assert_nil merchant.vat_nr
      assert_nil merchant.country
      assert_nil merchant.sector
      assert_nil merchant.notify_url
    end
  end

  def test_it_gives_back_all_the_merchants
    VCR.use_cassette('all_merchants') do
      result = OnlineBetaalPlatform::Merchant.all

      assert_equal 10, result.length

      assert result.is_a?(Array)
      assert result.first.is_a?(OnlineBetaalPlatform::Merchant)
    end
  end

  def test_it_creates_a_business_merchant
    VCR.use_cassette('create_business_merchant') do
      attributes = {
        emailaddress: "bob#{Time.now.to_i}@marley.com", phone: '123123123',
        type: 'business', country: 'nld', coc_nr: '123123123'
      }
      merchant = OnlineBetaalPlatform::Merchant.create(attributes)
      assert merchant.is_a?(OnlineBetaalPlatform::Merchant)
    end
  end

  def test_it_creates_a_consumer_merchant
    VCR.use_cassette('create_consumer_merchant') do
      attributes = {
        emailaddress: "kymani#{Time.now.to_i}@marley.com", name_first: 'Kymani',
        name_last: 'Marley', phone: '321321321', type: 'consumer',
        country: 'nld'
      }
      merchant = OnlineBetaalPlatform::Merchant.create(attributes)
      assert merchant.is_a?(OnlineBetaalPlatform::Merchant)
    end
  end

  def test_it_gets_bank_accounts
    VCR.use_cassette('merchant_bank_accounts', record: :new_episodes) do
      merchant = OnlineBetaalPlatform::Merchant.find('mer_09c609a961db')
      bank_accounts = merchant.bank_accounts
      assert_equal OnlineBetaalPlatform::BankAccount, bank_accounts.first.class
    end
  end
end
