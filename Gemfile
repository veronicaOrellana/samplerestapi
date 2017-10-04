source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "google-api-client"
gem 'restforce'
gem 'omniauth-salesforce'

group :development, :test do
  gem "rspec"
end