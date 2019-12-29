require "sinatra"
require "json"
require "./db/models.rb"
require "./app_ext.rb"

get "/devices" do
  content_type :json

  json = Device.all.as_json(:except => [ :id, :created_at])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end
get "/accounts" do
  content_type :json

  json = Account.all.as_json(:except => [ :id, :created_at, :token])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end
get "/children" do
  content_type :json

  json = Child.all.as_json(:except => [ :id, :created_at])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end
get "/parents" do
  content_type :json

  json = Parent.all.as_json(:except => [ :id, :created_at])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end

post "/authorise" do
  content_type :json

  device_id = params[:device_id]
  device = Device.find_by(device_id: device_id)
  if !device
    device = Device.build_new(device_id)
    device.save
  end
  
  json = device.as_json(:except => [ :id, :created_at])
  if account = device.account
    if account.parent
      json.account_role = "parent"
    elsif account.child
      json.account_role = "child"
    end
  end

  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end

get "/account" do
  content_type :json

  device_id = params[:id]
  device = Device.find_by(device_id: device_id)
  if !device
    device = Device.build_new(device_id)
    device.save
  end
  
  json = device.as_json(:except => [ :id, :created_at])
  if account = device.account
    if account.parent
      json.account_role = "parent"
    elsif account.child
      json.account_role = "child"
    end
  end

  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end

put "/child" do
  content_type :json

  token = params[:token]
  if !validDeviceIdAndToken(device_id, token)
    return
  end
  name = params[:name]

  if device.account != nil
    status 403
    put "Device already has account"
    return
  end

  child = Child.build_new(device, name)
  child.save

  json = child.as_json(:except => [ :id, :created_at], :include => [ :account ])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end

put "/parents" do
  content_type :json

  token = params[:token]
  if !validDeviceIdAndToken(device_id, token)
    return
  end
  name = params[:name]

  if device.account != nil
    status 403
    put "Device already has account"
    return
  end

  parent = Parent.build_new(device, name)
  parent.save

  json = parent.as_json(:except => [ :id, :created_at])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end

not_found do
  status 404
  erb :default
end
