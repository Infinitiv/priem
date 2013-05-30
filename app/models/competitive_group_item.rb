class CompetitiveGroupItem < ActiveRecord::Base
  belongs_to :competitive_group
  attr_accessible :direction_id, :education_level_id, :number_budget_o, :number_budget_oz, :number_budget_z, :number_paid_o, :number_paid_oz, :number_paid_z, :number_target_o, :number_target_oz, :number_target_z
end
