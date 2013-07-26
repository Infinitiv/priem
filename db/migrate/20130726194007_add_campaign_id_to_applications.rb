class AddCampaignIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :campaign_id, :integer
  end
end
