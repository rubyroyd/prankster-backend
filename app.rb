require "sinatra"
require "json"
require "./db/models.rb"

get "/devices/:id" do
  content_type :json

  device_id = params[:id]
  device = Device.find_by(device_id: device_id)
  if !device
    device = Device.build_fresh(device_id)
    device.save
  end
  
  json = device.as_json(:except => [ :id, :created_at])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end

get "/devices" do
  content_type :json

  json = Device.all.as_json(:except => [ :id, :created_at])
  json_string = JSON.pretty_generate(json)
  puts json_string
  status 200
  json_string
end

post "/devices/:id" do
  content_type :json

  role = params[:role]

  device_id = params[:id]
  device = Device.find_by(device_id: device_id)
  if !device
    status 404
    return "Device not found"
  end

  device.role = role
  device.save

  status 200
  return "Assigned role " + device.role + " to device"
end

not_found do
  status 404
  erb :default
end
