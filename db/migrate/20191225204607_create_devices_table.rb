class CreateDevicesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :device_id
      t.string :token
      t.column :role, :integer, default: 0
    end
  end
end
