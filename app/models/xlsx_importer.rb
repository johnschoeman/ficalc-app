class XlsxImporter < FileImporter
  attr_reader :builder

  def initialize(filename, user_id)
    super
    @builder = XlsxBuilder.new
  end

  def import
    workbook = RubyXL::Parser.parse(file_path)
    worksheet = workbook.worksheets.first
    worksheet.each_with_index do |row, idx|
      if idx == 0
        next
      end
      raw_data = builder.build(row, user_id)
      datum = FinancialDatum.new(raw_data)
      datum.save
    end
  end
end
