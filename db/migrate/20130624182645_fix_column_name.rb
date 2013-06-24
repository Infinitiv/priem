class FixColumnName < ActiveRecord::Migration
  def up
    remove_column :applications, :document_series
    add_column :applications, :document_series, :string
    add_column :applications, :edu_document_series, :string
  end

  def down
  end
end
