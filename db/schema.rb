# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_29_134448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "device_id"
    t.string "name"
    t.bigint "child_id"
    t.bigint "parent_id"
    t.index ["child_id"], name: "index_accounts_on_child_id"
    t.index ["device_id"], name: "index_accounts_on_device_id"
    t.index ["parent_id"], name: "index_accounts_on_parent_id"
  end

  create_table "childs", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "parent_id"
    t.bigint "region_status_id"
    t.bigint "region_setting_id"
    t.float "last_location_lat"
    t.float "last_location_long"
    t.datetime "last_location_timestamp"
    t.index ["account_id"], name: "index_childs_on_account_id"
    t.index ["parent_id"], name: "index_childs_on_parent_id"
    t.index ["region_setting_id"], name: "index_childs_on_region_setting_id"
    t.index ["region_status_id"], name: "index_childs_on_region_status_id"
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "account_id"
    t.string "device_id"
    t.string "token"
    t.index ["account_id"], name: "index_devices_on_account_id"
  end

  create_table "parents", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "child_id"
    t.bigint "region_id"
    t.index ["account_id"], name: "index_parents_on_account_id"
    t.index ["child_id"], name: "index_parents_on_child_id"
    t.index ["region_id"], name: "index_parents_on_region_id"
  end

  create_table "region_settings", force: :cascade do |t|
    t.bigint "child_id"
    t.bigint "region_id"
    t.boolean "notify_inside"
    t.boolean "notify_outside"
    t.index ["child_id"], name: "index_region_settings_on_child_id"
    t.index ["region_id"], name: "index_region_settings_on_region_id"
  end

  create_table "region_statuses", force: :cascade do |t|
    t.bigint "child_id"
    t.bigint "region_id"
    t.boolean "inside"
    t.boolean "outside"
    t.index ["child_id"], name: "index_region_statuses_on_child_id"
    t.index ["region_id"], name: "index_region_statuses_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.bigint "parent_id"
    t.string "name"
    t.float "lat"
    t.float "long"
    t.integer "radius"
    t.index ["parent_id"], name: "index_regions_on_parent_id"
  end

end
