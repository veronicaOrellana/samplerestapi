require_relative "../lib/checkAccessModule/accessGoogle"

describe AccessGoogleSpreadSheet do

  before do
    @object = AccessGoogleSpreadSheet.new()
  end

  describe ".authorize" do
    context "given an empty string for client_secret.json" do
      it "returns Google::Apis::SheetsV4::Spreadsheet instance" do
        response = @object.authorize('','1KK432FFgQ18lP-juSq10ae1ZX1lfa7FTELQFY9bDC38')
        expect(response[0]).to be_instance_of(Google::Apis::SheetsV4::Spreadsheet )
      end
    end

    context "given nil for client_secrets.json" do
      it "returns Google::Apis::SheetsV4::Spreadsheet instance" do
        response = @object.authorize('1KK432FFgQ18lP-juSq10ae1ZX1lfa7FTELQFY9bDC38')
        expect(response[0]).to be_instance_of(Google::Apis::SheetsV4::Spreadsheet)
      end
    end

    context "given a valid client_secret.json" do
      it "returns Google::Apis::SheetsV4::Spreadsheet instance" do
        response = @object.authorize('client_secret_google.json','1KK432FFgQ18lP-juSq10ae1ZX1lfa7FTELQFY9bDC38')
        expect(response[0]).to be_instance_of(Google::Apis::SheetsV4::Spreadsheet)
      end
    end

    context "given an invalid client_secrets_file" do
      it "returns nil" do
        response = @object.authorize('client_secret_invalid.json','1KK432FFgQ18lP-juSq10ae1ZX1lfa7FTELQFY9bDC38')
        expect(response[0]).to be_nil
      end
    end

    context "given an empty value for spreadsheet id" do
      it "returns nil" do
        response = @object.authorize('','')
        expect(response[0]).to be_nil
      end
    end

    context "given an invalid value for spreadsheet id" do
      it "returns nil" do
        response = @object.authorize('','2KK432FFgQ18lP-juSq10ae1ZX1lfa7FTELQFY9bDC38')
        expect(response[0]).to be_nil
      end
    end

  end
end

