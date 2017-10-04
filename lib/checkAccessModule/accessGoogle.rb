require 'bundler'
require 'google/apis/sheets_v4'
require 'googleauth'
require_relative '../constants'

Bundler.require


class AccessGoogleSpreadSheet

  def authorize (client_secrets = nil, spreadsheet_id)
    begin
      raise ArgumentError, 'empty spreadsheet_id argument' if spreadsheet_id.to_s.strip.empty?
      client_secrets_file = client_secrets.to_s.strip.empty? ? Constants::CLIENT_SECRETS_FILE: client_secrets
      client_secrets_path = File.join(File.dirname(__FILE__), '../../config/' + client_secrets_file)
      message = ''
      service = Google::Apis::SheetsV4::SheetsService.new
      service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(client_secrets_path), scope: Constants::SCOPE)
      spreadsheet = service.get_spreadsheet(spreadsheet_id.to_s)
    rescue Exception => e
      message = e.message
    end
    [spreadsheet, message]
  end
end
