class CreateEntranceTestItems < ActiveRecord::Migration
  def change
    create_table :entrance_test_items do |t|
      t.integer :entrance_test_type_id
      t.string :form
      t.integer :min_score

      t.timestamps
    end
  end
end
