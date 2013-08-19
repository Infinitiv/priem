class AddColumnToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :original_received_date, :date
  end
end
