require 'rails_helper'

RSpec.describe SalesforceData, type: :model do

  before(:all) do
    @ldLink = 'https://docs.google.com/spreadsheets/d/1TKL6AFxsdJTFWOZ0JE7gVzVks4eR_O4qIYE6vekDF3k/edit?usp=drive_web'
    @json = '{"data": "236d568fd99aa18720e4136","response": "true","status": "ok"}'
  end

  def create_object
    salesforce = SalesforceData.create(opportunityID: Faker::Number.number(6),
                                       transactionID:Faker::Number.number(6),
                                       goUserID:Faker::Number.number(6),
                                       dateTimeStamp:Faker::Time.backward(1, :evening),
                                       ldLink:@ldLink,
                                       json: @json)
  end

  context 'create a new salesforce row' do
    it 'returns true' do
      salesforce = SalesforceData.new
      salesforce.opportunityID = Faker::Number.number(6)
      salesforce.transactionID = Faker::Number.number(6)
      salesforce.goUserID = Faker::Number.number(6)
      salesforce.dateTimeStamp = Faker::Time.backward(1, :evening)
      salesforce.ldLink = @ldLink
      salesforce.json = @json
      expect(salesforce.save).to eq(true)
    end
  end

  context 'create a new salesforce row with null data' do
    it 'returns false' do
      salesforce = SalesforceData.new(opportunityID:nil,
                                      transactionID:nil,
                                      goUserID:nil,
                                      dateTimeStamp:nil,
                                      ldLink:@ldLink,
                                      json: nil)
      expect(salesforce.save).to eq(false)
    end
  end

  context 'update a salesforce row' do
    it 'returns true' do
      salesforce = create_object
      salesforce = SalesforceData.find_by(id:salesforce.id)
      salesforce.dateTimeStamp = Faker::Time.backward(1, :evening)
      expect(salesforce.save).to eq(true)
    end
  end

  context 'find all salesforce with goUserID created' do
    it 'return all rows with goUserID' do
      salesforce = create_object
      salesforce = SalesforceData.where(goUserID: salesforce.goUserID).order(created_at: :desc)
      expect(salesforce).to match_array(SalesforceData)
    end
  end
end
