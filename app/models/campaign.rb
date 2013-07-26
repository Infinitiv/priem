class Campaign < ActiveRecord::Base
  has_many :education_forms
  has_many :education_levels
  has_many :campaign_dates
  has_many :applications
  attr_accessible :name, :year_end, :year_start, :status_id
end
