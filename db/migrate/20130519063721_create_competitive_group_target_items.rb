class CreateCompetitiveGroupTargetItems < ActiveRecord::Migration
  def change
    create_table :competitive_group_target_items do |t|
      t.references :target_organization
      t.integer :education_level
      t.integer :number_target_o
      t.integer :number_target_oz
      t.integer :number_target_z
      t.integer :direction_id

      t.timestamps
    end
    add_index :competitive_group_target_items, :target_organization_id
  end
end
