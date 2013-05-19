class EducationForm < ActiveRecord::Base
  belongs_to :campaign
  attr_accessible :education_form_id, :campaign_id
end
