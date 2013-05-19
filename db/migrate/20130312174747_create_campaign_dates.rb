class CreateCampaignDates < ActiveRecord::Migration
  def change
    create_table :campaign_dates do |t|
      t.integer :course
      t.references :education_level
      t.references :education_form
      t.references :education_source
      t.integer :stage
      t.date :date_start
      t.date :date_end
      t.date :date_order
      t.references :campaign

      t.timestamps
    end
    add_index :campaign_dates, :education_form_id
    add_index :campaign_dates, :education_source_id
    add_index :campaign_dates, :campaign_id
  end
end
