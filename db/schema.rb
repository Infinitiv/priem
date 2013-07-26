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

ActiveRecord::Schema.define(:version => 20130726194007) do

  create_table "admission_volumes", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "education_level_id"
    t.integer  "course"
    t.integer  "direction_id"
    t.integer  "number_budget_o"
    t.integer  "number_budget_oz"
    t.integer  "number_budget_z"
    t.integer  "number_paid_o"
    t.integer  "number_paid_oz"
    t.integer  "number_paid_z"
    t.integer  "number_target_o"
    t.integer  "number_target_oz"
    t.integer  "number_target_z"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "admission_volumes", ["campaign_id"], :name => "index_admission_volumes_on_campaign_id"

  create_table "applications", :force => true do |t|
    t.integer  "application_number"
    t.integer  "identity_document_type_id"
    t.string   "document_number"
    t.date     "document_date"
    t.string   "entrant_last_name"
    t.string   "entrant_first_name"
    t.string   "entrant_middle_name"
    t.integer  "russian"
    t.integer  "chemistry"
    t.integer  "biology"
    t.integer  "target_organization_id"
    t.integer  "nationality_type_id"
    t.integer  "gender_id"
    t.date     "birth_date"
    t.integer  "edu_document_type_id"
    t.string   "edu_document_number"
    t.boolean  "need_hostel",               :default => false
    t.boolean  "lech_budget",               :default => false
    t.boolean  "ped_budget",                :default => false
    t.boolean  "stomat_budget",             :default => false
    t.boolean  "lech_paid",                 :default => false
    t.boolean  "ped_paid",                  :default => false
    t.boolean  "stomat_paid",               :default => false
    t.boolean  "original_received",         :default => false
    t.date     "registration_date"
    t.date     "last_dany_day"
    t.integer  "status_id",                 :default => 2
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "document_series"
    t.string   "edu_document_series"
    t.date     "edu_document_date"
    t.integer  "campaign_id"
  end

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

  create_table "competitive_group_items", :force => true do |t|
    t.integer  "competitive_group_id"
    t.integer  "education_level_id"
    t.integer  "direction_id"
    t.integer  "number_budget_o"
    t.integer  "number_budget_oz"
    t.integer  "number_budget_z"
    t.integer  "number_paid_o"
    t.integer  "number_paid_oz"
    t.integer  "number_paid_z"
    t.integer  "number_target_o"
    t.integer  "number_target_oz"
    t.integer  "number_target_z"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "competitive_group_items", ["competitive_group_id"], :name => "index_competitive_group_items_on_competitive_group_id"

  create_table "competitive_group_target_items", :force => true do |t|
    t.integer  "target_organization_id"
    t.integer  "education_level"
    t.integer  "number_target_o"
    t.integer  "number_target_oz"
    t.integer  "number_target_z"
    t.integer  "direction_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "competitive_group_target_items", ["target_organization_id"], :name => "index_competitive_group_target_items_on_target_organization_id"

  create_table "competitive_groups", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "course"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "competitive_groups", ["campaign_id"], :name => "index_competitive_groups_on_campaign_id"

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

  create_table "entrance_test_items", :force => true do |t|
    t.integer  "entrance_test_type_id"
    t.string   "form"
    t.integer  "min_score"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "competitive_group_id"
  end

  create_table "entrance_test_subjects", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "entrance_test_item_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "entrance_test_subjects", ["entrance_test_item_id"], :name => "index_entrance_test_subjects_on_entrance_test_item_id"

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

  create_table "target_organizations", :force => true do |t|
    t.integer  "competitive_group_id"
    t.string   "target_organization_name"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "target_organizations", ["competitive_group_id"], :name => "index_target_organizations_on_competitive_group_id"

end
