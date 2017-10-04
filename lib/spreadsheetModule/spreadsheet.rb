require 'bundler'
require 'google/apis/sheets_v4'
require 'googleauth'
require_relative '../constants'

Bundler.require

# Class to handle operations related to spreadsheet
class Spreadsheet

  def get_spreadsheet(spreadsheet_id)
    raise ArgumentError, 'empty spreadsheet_id argument' if spreadsheet_id.to_s.strip.empty?
    client_secrets_path = File.join(File.dirname(__FILE__), '../../config/' + Constants::CLIENT_SECRETS_GOOGLE)
    message = ''
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(client_secrets_path), scope: Constants::SCOPE)
    spreadsheet = service.get_spreadsheet(spreadsheet_id.to_s)
  end

  def get_service
    client_secrets_path = File.join(File.dirname(__FILE__), '../../config/' +
      Constants::CLIENT_SECRETS_GOOGLE)
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(client_secrets_path), scope: Constants::SCOPE)
    service
  end

  # method returns true if spreadsheet includes the tabs
  def existence_tabs(spreadsheet, tabs)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    titles = spreadsheet.sheets.map{|sheet| sheet.properties.title }
    response = tabs.all? { |e| titles.include?(e) }
  end

  # method returns the list of tabs included in the spreadsheet
  def existence_tabs_detail(spreadsheet, tabs)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    titles = spreadsheet.sheets.map{|sheet| sheet.properties.title }
    response = tabs.select{|tab| titles.include? tab}
  end

  # method that verify for each tab the existence of named ranges
  def verify_named_ranges_all_tabs(spreadsheet)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    nr_sheet_id = spreadsheet.named_ranges.map{|nr| nr.range.sheet_id }
    response = spreadsheet.sheets.select{|s| nr_sheet_id.include? s.properties.sheet_id}
  end

  # method that verify for some sheets the existence of named ranges
  def verify_named_ranges_list_tabs(spreadsheet, tab_names)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    sheets = spreadsheet.sheets.select{|s| tab_names.include? s.properties.title}
    nr_sheet_id = spreadsheet.named_ranges.map{|nr| nr.range.sheet_id }
    response = sheets.select{|s| nr_sheet_id.include? s.properties.sheet_id}
  end

  # Method verifies for each named range the existence of the "Fields"
  def verify_all_named_range_fields(spreadsheet, fields)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    response = {}
    spreadsheet.named_ranges.each do |nr|
      response[nr.name] = existence_named_range_fields spreadsheet, nr, fields[nr.name]
    end
    response
  end

  # Method verifies for a named range the existence of the "Fields"
  def existence_named_range_fields(spreadsheet, named_range, fields)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    raise ArgumentError, 'null argument for named_range parameter' if named_range.nil?
    service = get_service
    sheet = spreadsheet.sheets.find{|s| s.properties.sheet_id == named_range.range.sheet_id}
    range = named_range.range
    start_col = num_to_col (range.start_column_index + 1)
    end_col = num_to_col range.end_column_index
    range = sheet.properties.title + '!' + start_col.to_s + range.end_row_index.to_s + ':' + end_col.to_s
    values_range = service.get_spreadsheet_values(spreadsheet.spreadsheet_id, range)
    header = values_range.values.first.map(&:strip)
    response = fields.to_set == header.to_set ? true : false
  end

  # Read for each named range the values
  def get_data_all_named_range(spreadsheet)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    response = Hash.new
    spreadsheet.named_ranges.each do |nr|
      response[nr.name] = get_data_named_range spreadsheet, nr
    end
    response
  end

  # Read data from each field and check for conversion to correct format.
  def get_data_named_range(spreadsheet, named_range)
    raise ArgumentError, 'null argument for spreadsheet parameter' if spreadsheet.nil?
    raise ArgumentError, 'null argument for named_range parameter' if named_range.nil?
    service = get_service
    sheet = spreadsheet.sheets.find{|s| s.properties.sheet_id == named_range.range.sheet_id}
    range = get_range named_range, sheet
    values_range = service.get_spreadsheet_values(spreadsheet.spreadsheet_id, range)
    header = values_range.values.first.map(&:strip)
    values = values_range.values
                         .drop(1)
                         .map { |row| Hash[header.zip(row)] }
    i = 0
    values.each do |res|
      break if res.all? {|k,v| v.nil?}
      res.each do |k,v|
        values[i][k] = (delete_format v) unless v.nil?
      end
      i += 1
    end
    values = values.first i
  end

  def delete_format(value)
    data = currency_to_number value
    data = percentage_to_number data
    data = delete_escape_sequence data
  end

  def currency_to_number(currency)
    currency.gsub(/(^\$[0-9,.]+)/, (currency.delete '$'))
  end

  def percentage_to_number(percentage)
    percentage.gsub(/(^[0-9,.]+\%)/, (percentage.delete '%'))
  end

  def delete_escape_sequence(string)
    string.gsub(/(.+)\\t/, (string.chomp '\t'))
  end

  def get_range(named_range, sheet)
    range = named_range.range
    start_col = num_to_col (range.start_column_index + 1)
    end_col = num_to_col range.end_column_index
    rows = sheet.properties.grid_properties.row_count
    range = sheet.properties.title + '!' + start_col.to_s + range.end_row_index.to_s + ':' + end_col.to_s + rows.to_s
  end

  def num_to_col(num)
    raise("invalid value #{num} for num") unless num > 0
    result, remainder = num.divmod(26)
    if remainder == 0
      result -= 1
      remainder = 26
    end
    final_letter = ('a'..'z').to_a[remainder-1]
    result > 0 ? previous_letters = num_to_col(result) : previous_letters = ''
    "#{previous_letters}#{final_letter}".upcase
  end
end





