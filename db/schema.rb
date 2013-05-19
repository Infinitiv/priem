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

ActiveRecord::Schema.define(:version => 20130321091420) do

  create_table "auth_data", :force => true do |t|
    t.string   "login"
    t.string   "pass"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "campaign_dates", :force => true do |t|
    t.integer  "course"
    t.integer  "education_level_id"
    t.integer  "education_form_id"
    t.integer  "education_source_id"
    t.integer  "stage"
    t.date     "date_start"
    t.date     "date_end"
    t.date     "date_order"
    t.integer  "campaign_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "campaign_dates", ["campaign_id"], :name => "index_campaign_dates_on_campaign_id"
  add_index "campaign_dates", ["education_form_id"], :name => "index_campaign_dates_on_education_form_id"
  add_index "campaign_dates", ["education_source_id"], :name => "index_campaign_dates_on_education_source_id"

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.integer  "year_start"
    t.integer  "year_end"
    t.integer  "status_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "campaigns", ["status_id"], :name => "index_campaigns_on_status_id"

  create_table "education_forms", :force => true do |t|
    t.integer  "education_form_id"
    t.integer  "campaign_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "education_levels", :force => true do |t|
    t.integer  "course"
    t.integer  "education_level_id"
    t.integer  "campaign_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "queries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "requests", :force => true do |t|
    t.integer  "query_id"
    t.text     "input"
    t.text     "output"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "requests", ["query_id"], :name => "index_requests_on_query_id"

end
