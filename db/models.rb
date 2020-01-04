require "sinatra/activerecord"
require "securerandom"

class Device < ActiveRecord::Base
  has_one :account

  def self.new_token(device_id)
    device = Device.new
    device.device_id = device_id
    device.token = SecureRandom.uuid
    return device
  end

  def as_json(*)
    super.except("created_at", "id")
  end
end

class Account < ActiveRecord::Base
  has_one :device
  has_one :parent
  has_one :child

  def account_type?
    if parent
      return "parent"
    elsif child
      return "child"
    end
  end

  def as_json(*)
    super.except("created_at", "child_id", "parent_id").tap do |hash|
      hash["account_type"] = account_type?
    end
  end
end

class Parent < ActiveRecord::Base
  belongs_to :account
  has_many :child
  has_many :region

  def self.new_(device, name)
    parent = Parent.new

    account = Account.new
    account.device = device
    account.name = name

    parent.account = account

    return parent
  end

  def as_json(*)
    super.except("created_at", "id").tap do |hash|
      hash["account_id"] = account.id
      hash["name"] = account.name
    end
  end
end

class Child < ActiveRecord::Base
  belongs_to :account
  has_many :parent
  has_many :region
  has_many :region_status
  has_many :region_setting


  def self.new_(device, name)
    child = Child.new

    account = Account.new
    account.device = device
    account.name = name

    child.account = account

    return child
  end

  def as_json(*)
    super.except("created_at", "id").tap do |hash|
      hash["account_id"] = account.id
      hash["name"] = account.name
    end
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