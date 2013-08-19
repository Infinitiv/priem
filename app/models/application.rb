class Application < ActiveRecord::Base
  attr_accessible :application_number, :biology, :birth_date, :chemistry, :document_date, :edu_document_date, :document_number, :document_series, :edu_document_series, :edu_document_number, :edu_document_type_id, :entrant_first_name, :entrant_last_name, :entrant_middle_name, :gender_id, :identity_document_type_id, :last_dany_day, :lech_budget, :lech_paid, :nationality_type_id, :need_hostel, :original_received, :ped_budget, :ped_paid, :registration_date, :russian, :status_id, :stomat_budget, :stomat_paid, :target_organization_id, :campaign_id, :original_received_date
  
  belongs_to :campaign

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_application_number(row["application_number"]) || new
      product.attributes = row.to_hash.slice(*accessible_attributes)
      product.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".ods" then Roo::Openoffice.new(file.path, nil, :ignore)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
  def fio
    [entrant_last_name, entrant_first_name, entrant_middle_name].compact.join(' ')
  end
end
