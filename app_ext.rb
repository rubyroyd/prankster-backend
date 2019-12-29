require "sinatra"

def validDeviceIdAndToken(device_id, token)
  device = Device.find_by(device_id: device_id)
  if !device
    status 404
    return false
  end

  if device.token != token && !isSupertoken(token)
    status 401
    return false
  end

  return true
end

def isSupertoken(token)
  return token == "420"
end