require "sinatra/activerecord"
require "securerandom"

class Device < ActiveRecord::Base
  self.primary_key = "device_id"
  has_one :account

  def self.build_new(device_id)
    device = Device.new
    device.device_id = device_id
    device.token = SecureRandom.uuid
    return device
  end
end

class Account < ActiveRecord::Base
  has_one :parent
  has_one :child
end

class Parent < ActiveRecord::Base
  belongs_to :account
  has_many :child
  has_many :region

  def self.build_new(device, name)
    parent = Parent.new

    account = Account.new
    account.device = device
    account.name = name

    parent.account = account

    return parent
  end
end

class Child < ActiveRecord::Base
  belongs_to :account
  has_many :parent
  has_many :region
  has_many :region_status
  has_many :region_setting

  def self.build_new(device, name)
    child = Child.new

    account = Account.new
    account.device = device
    account.name = name

    child.account = account

    return child
  end
end

class Region  < ActiveRecord::Base
  belongs_to :parent
  has_many :child
end

class RegionStatus  < ActiveRecord::Base
  belongs_to :child
  belongs_to :region
end

class RegionSetting  < ActiveRecord::Base
  belongs_to :child
  belongs_to :region
end