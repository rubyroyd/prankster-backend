require "sinatra"
require "json"
require "./db/models.rb"
require "./app_ext.rb"

get "/devices" do
  success(200, Device.all.as_json)
end
get "/accounts" do
  success(200, Account.all.as_json)
end
delete "/accounts" do
  token = params[:token]
  id = params[:id]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  account = Account.find_by(id: id)
  if !account
    return error(200, "not exist")
  end

  account.child&.destroy
  account.parent&.destroy
  account.destroy
  success(201, "OK")
end
get "/children" do
  success(200, Child.all.as_json)
end
get "/parents" do
  success(200, Parent.all.as_json)
end

post "/authorise" do
  device_id = params[:device_id]
  device = Device.find_by(device_id: device_id)
  if !device
    device = Device.new_token(device_id)
    device.save
  end
  
  response_json = device.as_json
  response_json["account_id"] = device.account&.id
  response_json["account_role"] = device.account&.account_role

  return success(200, response_json)
end

post "/accounts/children" do
  token = params[:token]
  name = params[:name]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  if device.account
    return error(403, "child already created")
  end

  child = Child.new_(device, name)
  child.save
  response_json = child.as_json
  success(201, response_json)
end

post "/accounts/parents" do
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

  parent = Parent.new_(device, name)
  parent.save
  response_json = parent.as_json
  success(201, response_json)
end

not_found do
  status 404
  erb :default
end

def success(statusCode, response = {})
  result = {"status" => "ok"}
  result["response"] = response
  status statusCode

  pretty_response = JSON.pretty_generate(result)
  puts pretty_response
  return pretty_response
end

def error(statusCode, errorDescription = "")
  result = {"status" => "error"}
  result["error"] = errorDescription
  status statusCode

  pretty_response = JSON.pretty_generate(result)
  puts pretty_response
  return pretty_response
end