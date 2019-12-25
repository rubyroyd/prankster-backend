require "sinatra"
require "./db/models.rb"

get "/devices/:id" do
  device_id = params[:id]
  device = Device.find_by(device_id: device_id)
  if !device
    device = Device.build_fresh(device_id)
    device.save
  end
  puts device.to_yaml
  puts device.role

  @display_devices = [device]
  erb :devices
end

get "/devices" do
  @display_devices = Device.all
  erb :devices
end

not_found do
  status 404
  erb :default
end
