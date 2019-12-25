require "sinatra/activerecord"
require "securerandom"

class Device < ActiveRecord::Base
  enum role: [:none, :child, :parent], _suffix: true
  self.primary_key = "device_id"

  def self.build_fresh(device_id)
    device = Device.new
    device.device_id = device_id
    device.token = SecureRandom.uuid
    device.role = "none"
    return device
  end
end
