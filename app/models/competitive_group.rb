class CompetitiveGroup < ActiveRecord::Base
  belongs_to :campaign
  attr_accessible :course, :name
  has_many :competitive_group_items
  has_many :target_organizations
  has_many :entrance_test_items
end
