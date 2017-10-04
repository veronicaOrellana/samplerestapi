class CreateSalesforceData < ActiveRecord::Migration
  def change
    create_table :salesforce_data do |t|
      t.string :opportunityID
      t.string :transactionID
      t.string :goUserID
      t.datetime :dateTimeStamp
      t.string :ldLink
      t.text :json

      t.timestamps null: false
    end
  end
end
