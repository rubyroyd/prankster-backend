require "sinatra"
require "./db/models.rb"
require "./app_ext.rb"

before do
  content_type :json
end
not_found do
  status 404
  erb :not_found
end

post "/debug/test" do
  param1 = params[:param1]
  param2 = params[:param2]
  
  response_json = { "p1" => param1, "p2" => param2 }
  success(201, response_json)
end
get "/debug/devices" do
  success(200, Device.all.as_json)
end
get "/debug/accounts" do
  success(200, Account.all.as_json)
end
get "/debug/children" do
  success(200, Child.all.as_json)
end
get "/debug/parents" do
  success(200, Parent.all.as_json)
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

post "/authorise" do
  device_id = params[:device_id]

  if !device_id
    return error(500, "no device id")
  end
  
  device = Device.find_by(device_id: device_id)
  if !device
    device = Device.new_token(device_id)
    device.save
  end

  success(200, device.as_json)
end

post "/accounts/children/new" do
  token = params[:token]
  name = params[:name]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  if device.account
    return error(403, "account already created")
  end

  child = Child.new_(device, name)
  child.save
  
  success(201, child.as_json)
end
post "/accounts/parents/new" do
  token = params[:token]
  name = params[:name]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  if device.account
    return error(403, "account already created")
  end

  parent = Parent.new_(device, name)
  parent.save
  
  success(201, parent.as_json)
end

get "/accounts/parents/:id" do
  parent_id = params[:id].to_i
  token = params[:token]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  parent=device.account&.parent
  if !parent
    return error(403, "device doesn't have account")
  end

  if parent.account.id != parent_id
    return error(403, "no access to this parent")
  end

  success(200, parent.as_json)
end
post "/accounts/parents/:id/assign_child" do
  parent_id = params[:id].to_i
  child_id = params[:child_id].to_i
  token = params[:token]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  parent=device.account&.parent
  if !parent
    return error(403, "device doesn't have account")
  end

  if parent.account.id != parent_id
    return error(403, "no access to this parent")
  end

  child = Account.find_by(id: child_id).child
  if !child
    return error(403, "no child found for this id")
  end

  if child.parent_id
    return error(403, "child already assigned")
  end

  child.parent_id = parent.id
  child.save
  parent.child_id = child.id
  parent.save

  success(200, parent.as_json)
end

get "/accounts/children/:id" do
  child_id = params[:id].to_i
  token = params[:token]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  child=device.account&.child
  if !child
    return error(403, "device doesn't have account")
  end

  if child.account.id != child_id
    return error(403, "no access to this child")
  end

  success(200, child.as_json)
end

def success(statusCode, response = {})
  result = {"status" => "ok"}
  result["response"] = response
  status statusCode

  pretty_result = JSON.pretty_generate(result)
  puts pretty_result
  pretty_result
end
def error(statusCode, errorDescription = "")
  result = {"status" => "error"}
  result["error"] = errorDescription
  status statusCode

  pretty_result = JSON.pretty_generate(result)
  puts pretty_result
  pretty_result
end
