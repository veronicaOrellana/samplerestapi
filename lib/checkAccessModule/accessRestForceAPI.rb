require 'bundler'
require_relative '../constants'

Bundler.require

API_VERSION = '38.0'

class AccessRestForceAPI

  def authorize
    begin
      message = ''
      client_secrets_file = File.join(File.dirname(__FILE__), '../../config/'+ Constants::CLIENT_SECRETS_RESTFORCE)
      file = File.read client_secrets_file
      data = JSON.parse(file)
      client = Restforce.new  :username => data['username'],
                              :password       => data['password'],
                              :security_token => data['security_token'],
                              :client_id      => data['client_id'],
                              :client_secret  => data['client_secret'],
                              :api_version => API_VERSION

      client.authenticate!
    rescue Exception => e
      message = e.message
      client = nil
    end
    [client, message]
  end
end