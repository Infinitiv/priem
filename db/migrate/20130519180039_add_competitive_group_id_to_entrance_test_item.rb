class AddCompetitiveGroupIdToEntranceTestItem < ActiveRecord::Migration
  def change
    add_column :entrance_test_items, :competitive_group_id, :integer
  end
end
