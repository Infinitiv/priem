class CreateEntranceTestSubjects < ActiveRecord::Migration
  def change
    create_table :entrance_test_subjects do |t|
      t.integer :subject_id
      t.references :entrance_test_item

      t.timestamps
    end
    add_index :entrance_test_subjects, :entrance_test_item_id
  end
end
