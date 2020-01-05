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
    result = super(except: [:account_id, :created_at, :id])
    result[:account] = account ? account.as_json : nil
    result
  end
end

class Account < ActiveRecord::Base
  has_one :device
  has_one :parent
  has_one :child

  def type
    if parent
      return "parent"
    elsif child
      return "child"
    else
      return null
    end
  end

  def as_json(*)
    super(except: [:device_id, :created_at, :child_id, :parent_id], methods: :type, include: [:child, :parent])
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
    result = super(except: [:created_at, :region_id], include: :child)
    result[:name] = account.name
    result
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
    result = super(except: [:created_at, :region_id], include: :parent)
    result[:name] = account.name
    result
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