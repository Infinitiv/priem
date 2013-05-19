class CreateEducationForms < ActiveRecord::Migration
  def change
    create_table :education_forms do |t|
      t.references :education_form
      t.references :campaign

      t.timestamps
    end
  end
end
