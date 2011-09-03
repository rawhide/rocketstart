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

ActiveRecord::Schema.define(:version => 20110729053136) do

  create_table "activation_tokens", :force => true do |t|
    t.string   "email"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "remined"
    t.integer  "user_id"
  end

  create_table "alert_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "text"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alert_messages", ["company_id"], :name => "index_alert_messages_on_company_id"
  add_index "alert_messages", ["user_id"], :name => "index_alert_messages_on_user_id"

  create_table "approval_form_fields", :force => true do |t|
    t.integer  "approval_form_id"
    t.string   "title"
    t.string   "form_type"
    t.text     "item"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approval_forms", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "header_text"
    t.string   "fotter_text"
    t.string   "complete_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approval_values", :force => true do |t|
    t.integer  "approval_id"
    t.integer  "approval_form_field_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approval_workflows", :force => true do |t|
    t.integer  "approval_id"
    t.integer  "user_id"
    t.integer  "step"
    t.integer  "user_type"
    t.boolean  "accept",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approvals", :force => true do |t|
    t.integer  "company_id"
    t.integer  "approval_form_id"
    t.integer  "user_id"
    t.integer  "status",           :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comapnies", :force => true do |t|
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

  create_table "hoges", :force => true do |t|
    t.string   "title"
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

  create_table "master_official_companies", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "address"
    t.string   "category"
    t.date     "expiration_date"
    t.string   "agency"
    t.string   "jis_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "master_official_companies", ["code"], :name => "index_master_official_companies_on_code"

  create_table "schedules", :force => true do |t|
    t.string   "loop_group_id",        :default => "0"
    t.string   "type"
    t.integer  "owner_id",             :default => 0
    t.string   "title"
    t.string   "memo"
    t.integer  "start_year",           :default => 0
    t.integer  "start_month",          :default => 0
    t.integer  "start_day",            :default => 0
    t.integer  "start_hour",           :default => 0
    t.integer  "start_minute",         :default => 0
    t.integer  "end_year",             :default => 0
    t.integer  "end_month",            :default => 0
    t.integer  "end_day",              :default => 0
    t.integer  "end_hour",             :default => 0
    t.integer  "end_minute",           :default => 0
    t.boolean  "all_day"
    t.integer  "loop_unit",            :default => 0
    t.datetime "loop_limit"
    t.string   "loop_week_days"
    t.integer  "loop_month_unit_type", :default => 0
    t.integer  "loop_unit_type",       :default => 0
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

  create_table "users_schedules", :force => true do |t|
    t.integer  "user_id"
    t.integer  "schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflow_templates", :force => true do |t|
    t.integer  "approval_form_id"
    t.integer  "step"
    t.integer  "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
