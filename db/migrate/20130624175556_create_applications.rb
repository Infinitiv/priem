class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :application_number
      t.integer :identity_document_type_id
      t.string :document_series
      t.string :document_number
      t.date :document_date
      t.string :entrant_last_name
      t.string :entrant_first_name
      t.string :entrant_middle_name
      t.integer :russian
      t.integer :chemistry
      t.integer :biology
      t.integer :target_organization_id
      t.integer :nationality_type_id
      t.integer :gender_id
      t.date :birth_date
      t.integer :edu_document_type_id
      t.string :document_series
      t.string :edu_document_number
      t.integer :document_date
      t.boolean :need_hostel, :default => false
      t.boolean :lech_budget, :default => false
      t.boolean :ped_budget, :default => false
      t.boolean :stomat_budget, :default => false
      t.boolean :lech_paid, :default => false
      t.boolean :ped_paid, :default => false
      t.boolean :stomat_paid, :default => false
      t.boolean :original_received, :default => false
      t.date :registration_date
      t.date :last_dany_day
      t.integer :status_id, :default => 2

      t.timestamps
    end
  end
end
