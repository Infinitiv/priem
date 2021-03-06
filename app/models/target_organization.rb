class TargetOrganization < ActiveRecord::Base
  belongs_to :competitive_group
  attr_accessible :target_organization_name, :competitive_group_id
  has_many :competitive_group_target_items
end
