class CreateEducationLevels < ActiveRecord::Migration
  def change
    create_table :education_levels do |t|
      t.integer :course
      t.references :education_level
      t.references :campaign

      t.timestamps
    end
  end
end
