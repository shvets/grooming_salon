# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 14) do

  create_table "appointments", :force => true do |t|
    t.date     "appointment_date"
    t.time     "appointment_time"
    t.float    "price",            :default => 0.0
    t.integer  "pet_owner_id"
    t.integer  "groomer_id"
    t.integer  "pet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appointments", ["pet_id"], :name => "fk_appointments_pet_id"
  add_index "appointments", ["groomer_id"], :name => "fk_appointments_groomer_id"

  create_table "breeds", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "subtype",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "fax"
    t.string   "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "four_oh_fours", :force => true do |t|
    t.string   "host"
    t.string   "path"
    t.string   "referer"
    t.integer  "count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "four_oh_fours", ["host", "path", "referer"], :name => "index_four_oh_fours_on_host_and_path_and_referer", :unique => true
  add_index "four_oh_fours", ["path"], :name => "index_four_oh_fours_on_path"

  create_table "groomers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "notes"
    t.string   "address"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groomers", ["company_id"], :name => "fk_groomers_company_id"

  create_table "pet_images", :force => true do |t|
    t.string  "filename"
    t.string  "content_type"
    t.integer "pet_id"
  end

  create_table "pet_owners", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "cell_phone"
    t.string   "salutation"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pet_owners", ["company_id"], :name => "fk_pet_owners_company_id"

  create_table "pets", :force => true do |t|
    t.string   "subtype"
    t.string   "name"
    t.string   "sex"
    t.string   "breed"
    t.string   "color"
    t.string   "size"
    t.datetime "birth_date"
    t.string   "veterinar"
    t.string   "referred_by"
    t.text     "medical_problems"
    t.text     "special_instructions"
    t.text     "behavior"
    t.string   "clip1"
    t.string   "clip2"
    t.string   "clip3"
    t.integer  "pet_owner_id"
    t.string   "alive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "table"
    t.string   "condition"
    t.string   "controller"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.boolean  "admin"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "email"
    t.string   "cookie_hash"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["company_id"], :name => "fk_users_company_id"

end
