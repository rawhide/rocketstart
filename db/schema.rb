# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110726080354) do

  create_table "activation_tokens", :force => true do |t|
    t.string   "email"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "remined"
    t.integer  "user_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "scale"
    t.string   "code"
    t.string   "category"
    t.date     "expiration_date"
    t.string   "agency"
    t.string   "jis_code"
    t.integer  "status",          :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_change_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitation_tokens", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "user_type"
    t.string   "code"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sex",        :default => 1
    t.string   "position"
    t.string   "section"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "company_id"
    t.string   "email",                           :null => false
    t.string   "type"
    t.string   "name"
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "status",           :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
