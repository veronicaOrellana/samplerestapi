require_relative "../lib/checkAccessModule/accessRestForceAPI"

describe AccessRestForceAPI do

  describe ".authorize" do
    context "try connecting with client_secret_restforce.json file" do
      it "returns Restforce::Data::Client instance" do
        object = AccessRestForceAPI.new()
        response = object.authorize()
        expect(response[0]).to be_instance_of(Restforce::Data::Client)
      end
    end
  end
end

