class FixColumnNameEducationLevel < ActiveRecord::Migration
  def up
  	rename_column :education_levels, :education_form_id, :campaign_id
  end

  def down
  end
end
