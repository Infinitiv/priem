class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :year_start
      t.integer :year_end
      t.references :status

      t.timestamps
    end
  end
end
