require_relative '../lib/spreadsheetModule/spreadsheet'

describe Spreadsheet do
  before do
    @sheets = Spreadsheet.new()
    @obj = @sheets.get_spreadsheet('1TKL6AFxsdJTFWOZ0JE7gVzVks4eR_O4qIYE6vekDF3k')
  end
  describe '.existence_tabs' do
    context 'Check existence of tabs' do
      it 'returns true if spreadsheet includes the tabs' do
        tabs = ['Summary','FB Creative', 'Pixels','FBIG Mixed Creative', 'FB Audiences', 'TW Creative','TW Audiences','SC Creative','PI Creative','PI Audiences','IG Creative','IG Audiences','SC Audiences','Validations','ChangeLog']
        response = @sheets.existence_tabs(@obj, tabs)
        expect(response).to be true
      end
    end
  end

  describe '.existence_tabs_detail' do
    context 'Check existence of tabs' do
      it 'returns the list of tabs included in the spreadsheet' do
        tabs = ['Summary','FB Creative', 'Pixels']
        response = @sheets.existence_tabs_detail(@obj, tabs)
        expect(response.size).to eq(3)
      end
    end
  end

  describe '.verify_named_ranges_all_tabs' do
    context 'Check for all tabs the existence of named ranges' do
      it 'returns the sheets with named ranges' do
        response = @sheets.verify_named_ranges_all_tabs(@obj)
        expect(response.size).to eq(4)
      end
    end
  end

  describe '.verify_named_ranges_list_tabs' do
    context 'Check for each tab the existence of named ranges' do
      it 'returns the list of sheets with named ranges' do
        tabs = ['Summary','FB Creative', 'Pixels']
        response = @sheets.verify_named_ranges_list_tabs(@obj, tabs)
        expect(response.size).to eq(2)
      end
    end
  end

  describe '.verify_all_named_range_fields' do
    context 'Check for each named range the existence of the Fields' do
      it 'returns the list of named ranges with true value' do
        fields = Hash.new
        fields['S.IO_Level'] = ['Opportunity Name',	'Opportunity Link','Billable Budget','Media Budget','Agency / Client','Pricing Model','Fee %','SalesForce ID','FBM Account ID','Twitter Account','Twitter Funding Source ID','Pinterest Account',	'Snapchat Ad Account','Snapchat Organization','Report Frequency','Day Due','Time Due']
        fields['S.Tactics'] = ['Platform','Line Item Description','Billable Budget','Media Budget','Funding Type','Line Item ID','Start Date','End Date','Brand Page / Handle','Objective','Goal Metric','Goal Cost','Goal Units / Frequency Cap','Ad Type','Notes','Conversion Pixels','View Tags','Clicks Tags']
        fields['FA.FB_Audiences'] = ['Audience Segment Name','Target Type','Targeting',	'And / Or Criteria','Exclusion Audience',	'Is Targeting Approval Needed?','View Tags','Notes']
        fields['FC.Carousel'] = ['Post Name','Post ID','Post Text',	'Image / Video File','Destination URL','Headline','Description (Optional)','CTA Button','End Card',	'See More URL',	'See More Display URL (Optional)','Creative Optimization']
        fields['FC.Lead_Gen'] = ['Post Name',	'Post ID','Post Text','CTA Button',	'Link Headline','Display Link','Description','Image File','Headline','Image File','Benefit Text','Button Text','Question 1','Question 2','Question 3','Question 4','Privacy Policy URL','Privacy Policy Link Text','Title','Custom Disclaimer Body','Consent Check Box (Optional)','View Website Button URL']
        fields['FC.Post'] = ['Post Name','Notes','Ad Status','Line Item Description','Line Item ID','Type','Post Type','Objective','Billable Budget','Media Budget','Actualized Billable Spend','Start Date','End Date','View Tag','Placement','Gender','Age','Geo','Geo Radius','Audience Segments','Post URL','Post ID','URL','Post Text','CTA Button','Link Headline','Display Link','Description','Image / Video File',	'Video Thumbnail File']
        fields['FIMC.Carousel'] = ['Post Name','Post ID','Post Text','Image / Video File','Destination URL','Headline','Description (Optional)','CTA Button','End Card','See More URL','See More Display URL (Optional)','Creative Optimization']
        fields['FIMC.Post'] = ['Post Name','Notes','Ad Status','Line Item Description','Line Item ID','Type','Post Type','Objective','Billable Budget','Media Budget','Actualized Billable Spend','Start Date','End Date','View Tag','Placement','Gender','Age','Geo','Geo Radius',	'Audience Segments','Post URL','Post ID','URL',	'Post Text','CTA Button','Link Headline','Display Link','Description','Image / Video File','Video Thumbnail File']
        response = @sheets.verify_all_named_range_fields(@obj, fields)
        expect(response.size).to eq(8)
      end
    end
  end

  describe '.get_data_all_named_range' do
    context 'Read for each named range the values' do
      it 'returns a hash with all named ranges' do
        obj = @sheets.get_spreadsheet('1GPeZS0V_gmKowSVsA-OZSG54RO9Sw7FZUkXxvVR7E7M')
        response = @sheets.get_data_all_named_range(obj)
        expect(response.size).to eq(6)
      end
    end
  end

  describe '.currency_to_number' do
    context 'get number from currency' do
      it 'returns a number' do
        response = @sheets.currency_to_number('$449,077.20')
        expect(response).to eq('449,077.20')
      end
    end
  end

  describe '.percentage_to_number' do
    context 'get number from percentage' do
      it 'returns a number' do
        response = @sheets.percentage_to_number('12.00%')
        expect(response).to eq('12.00')
      end
    end
  end

  describe '.delete_escape_sequence' do
    context 'get a string without \t' do
      it 'a string without \t' do
        response = @sheets.delete_escape_sequence('Twin Peaks FB 1 Month\t')
        expect(response).to eq('Twin Peaks FB 1 Month')
      end
    end
  end

end
