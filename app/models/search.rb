class Search
  attr_reader :name, :organisation_number, :revenue, :registration_year, :phone, :address

  def initialize(search_term)
    @search_term = search_term
    search_for_company if search_term.present?
  end

  def as_json
    {
      name: @name,
      organisation_number: @organisation_number,
      revenue: @revenue,
      registration_year: @registration_year,
      phone: @phone,
      address: @address
    }
  end

  private

  def search_for_company
    # Encode search term
    search_term_encoded = URI.encode(@search_term)
    # Search on allabolag.se with the given search term
    doc = nokogiri_doc("http://www.allabolag.se/what/#{search_term_encoded}")
    # First search result
    search_result = doc.css('.search-results__item__details').first
    # If there was a match
    if search_result
      # Get the organisation number
      @organisation_number = search_result.css('dd').first.text
      get_company_info
    end
  end

  def get_company_info
    # Get detailed information about the company
    company_doc = nokogiri_doc("http://www.allabolag.se/#{@organisation_number.gsub "-", ""}")
    # Company name
    @name = get_attribute(company_doc, '.p-name')
    # Last year's revenue
    @revenue = get_attribute(company_doc, '*:contains("Omsättning") + *')
    # Registration year
    @registration_year = get_attribute(company_doc, 'dt:contains("Registreringsår") + dd')
    # Phone number
    @phone = get_attribute(company_doc, '.p-tel')
    # Address
    @address = get_attribute(company_doc, '*:contains("Besöksadress") + * *:first-child')
  end

  def get_attribute(company_doc, css_selector)
    attribute = company_doc.css(css_selector)
    attribute.empty? ? "not available" : attribute.first.text.strip
  end

  def nokogiri_doc(url)
    Nokogiri::HTML(open(url))
  end
end
