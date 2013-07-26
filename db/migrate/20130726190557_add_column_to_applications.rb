class AddColumnToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :edu_document_date, :date
  end
end
