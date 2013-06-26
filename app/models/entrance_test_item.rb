class EntranceTestItem < ActiveRecord::Base
  attr_accessible :competitive_group_id, :entrance_test_type_id, :form, :min_score
  has_many :entrance_test_subjects
end
