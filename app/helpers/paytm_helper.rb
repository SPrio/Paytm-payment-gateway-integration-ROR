# frozen_string_literal: true

module PaytmHelper
  require 'paytm/encryption_new_pg.rb'
  include EncryptionNewPG
  def generate_checksum
    new_pg_checksum(@paytmParam, Rails.application.secrets[:merchant_key]).gsub("\n", '')
  end

  def verify_checksum
    new_pg_verify_checksum(@paytmparams, @checksum_hash, Rails.application.secrets[:merchant_key])
  end
end
