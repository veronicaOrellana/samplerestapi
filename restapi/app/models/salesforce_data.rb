class SalesforceData < ActiveRecord::Base
  validates :opportunityID, presence: true
  validates :transactionID, presence: true
  validates :goUserID, presence: true
  validates :dateTimeStamp, presence: true
  validates :ldLink, presence: true
  validates :json, presence: true
end
