# frozen_string_literal: true

include PaytmHelper
module Paytm
  class StartPaymentService
    attr :request,
         :paytmParam,
         :checksum

    def initialize(_attribute, request)
      @request = request
    end

    def call
      get_param_list
    end

    private

    def get_param_list
      paytmParam = {}
      paytmParam['MID'] = Rails.application.secrets[:merchant_id]
      paytmParam['ORDER_ID'] = Time.now.to_i.to_s
      paytmParam['CUST_ID'] = Time.now.to_i.to_s
      paytmParam['INDUSTRY_TYPE_ID'] = Rails.application.secrets[:industry_type]
      paytmParam['CHANNEL_ID'] = Rails.application.secrets[:channel_id]
      paytmParam['TXN_AMOUNT'] = 1
      paytmParam['WEBSITE'] = Rails.application.secrets[:website]
      paytmParam['CALLBACK_URL'] =
        "#{request.protocol + request.host_with_port}/confirm_payment"
      @paytmParam = paytmParam
      @checksum = generate_checksum
    end
  end


  class VerifyPaymentService
    attr_reader :keys,
                :paytmparams,
                :is_valid_checksum

    def initialize(attribute, _cart)
      @attribute = attribute
      @keys = attribute.keys
    end

    def call
      paytm_params
    end

    private

    def paytm_params
      paytmparams = {}
      @keys.each do |k|
        paytmparams[k] = @attribute[k]
      end
      @checksum_hash = paytmparams['CHECKSUMHASH']
      paytmparams.delete('CHECKSUMHASH')
      paytmparams.delete('controller')
      paytmparams.delete('action')
      @paytmparams = paytmparams
      @is_valid_checksum = verify_checksum
    end
  end
end
