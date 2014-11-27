class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :url, null: false

      t.timestamps
    end
  end
end
