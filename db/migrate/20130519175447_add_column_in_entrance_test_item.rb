class AddColumnInEntranceTestItem < ActiveRecord::Migration
  def up
    change_table :entrance_test_item do |t|
      t.integer :competitive_group_id
    end
  end

  def down
  end
end
