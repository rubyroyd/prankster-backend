class Init < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.belongs_to :account

      t.string :device_id
      t.string :token
    end

    create_table :accounts do |t|
      t.references :device

      t.string :name
      t.references :child
      t.references :parent
    end

    create_table :parents do |t|
      t.belongs_to :account
      t.references :child
      t.references :region
    end

    create_table :children do |t|
      t.belongs_to :account
      t.references :parent

      t.references :region_status
      t.references :region_setting

      t.float :last_location_lat
      t.float :last_location_long
      t.datetime :last_location_timestamp
    end

    create_table :regions do |t|
      t.references :parent

      t.string :name
      t.float :lat
      t.float :long
      t.integer :radius
    end

    create_table :region_statuses do |t|
      t.references :child
      t.references :region

      t.boolean :inside
      t.boolean :outside
    end

    create_table :region_settings do |t|
      t.references :child
      t.references :region

      t.boolean :notify_inside
      t.boolean :notify_outside
    end
  end
end
