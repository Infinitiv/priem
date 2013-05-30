class CreateAdmissionVolumes < ActiveRecord::Migration
  def change
    create_table :admission_volumes do |t|
      t.references :campaign
      t.integer :education_level_id
      t.integer :course
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
    add_index :admission_volumes, :campaign_id
  end
end
