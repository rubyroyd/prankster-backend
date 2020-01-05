require "./db/models.rb"

def destroy_all
    Child.destroy_all
    Parent.destroy_all
    Device.destroy_all
    Account.destroy_all
end
def put_all
    puts Child.find_each.as_json
    puts Parent.find_each.as_json
    puts Device.find_each.as_json
    puts Account.find_each.as_json
end

destroy_all
# put_all

#------------------

def seed
    child_device = Device.new_token("1")
    child_device.save
    
    parent_device = Device.new_token("2")
    parent_device.save
    
    child = Child.new_(child_device, "Ребенок")
    child.save
    
    parent = Parent.new_(parent_device, "Родитель")
    parent.save
    
    child.parent_id = parent.id
    parent.child_id = child.id
    parent.save
    child.save           
    
    puts child.as_json
    puts parent.as_json
end

seed

#------------------

# put_all
