class CompetitiveGroupTargetItem < ActiveRecord::Base
  belongs_to :target_organization
  attr_accessible :direction_id, :education_level, :number_target_o, :number_target_oz, :number_target_z
end
