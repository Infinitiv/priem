class EducationLevel < ActiveRecord::Base
  belongs_to :campaign
  attr_accessible :course, :education_level_id, :campaign_id
end
