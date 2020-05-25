# frozen_string_literal: true

class PaytmController < ApplicationController
  include PaytmHelper
  include Paytm
  skip_before_action :verify_authenticity_token

  def start_payment
    start_payment = StartPaymentService.new(params, request)
    start_payment.call
    
    @checksum = start_payment.checksum
    @paytmParam = start_payment.paytmParam
    
  end

  def verify_payment
    paytm_verify = Paytm::VerifyPaymentService.new(params, @cart)
    paytm_verify.call
    @paytmparams = paytm_verify.paytmparams
    @is_valid_checksum = paytm_verify.is_valid_checksum
    if @is_valid_checksum == true
      if @paytmparams['STATUS'] == 'TXN_SUCCESS'
        respond_to do |format|
          format.html
        end
      else
        respond_to do |format|
          format.html
        end
      end
    end
  end

  def home
  end
end
