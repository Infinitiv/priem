class CreateCompetitiveGroupItems < ActiveRecord::Migration
  def change
    create_table :competitive_group_items do |t|
      t.references :competitive_group
      t.integer :education_level_id
      t.integer :direction_id
      t.integer :number_budget_o
      t.integer :number_budget_oz
      t.integer :number_budget_z
      t.integer :number_paid_o
      t.integer :number_paid_oz
      t.integer :number_paid_z
      t.integer :number_target_o
      t.integer :number_target_oz
      t.integer :number_target_z

      t.timestamps
    end
    add_index :competitive_group_items, :competitive_group_id
  end
end
