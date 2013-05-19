class CampaignDate < ActiveRecord::Base
  belongs_to :education_form
  belongs_to :education_source
  belongs_to :campaign
  attr_accessible :course, :date_end, :date_order, :date_start, :education_level_id, :stage, :campaign_id, :education_level_id, :education_form_id, :education_source_id
end
