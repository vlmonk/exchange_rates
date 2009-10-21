require 'net/http'
require 'uri'
require 'hpricot'

class ExchangeRates < ActiveRecord::Base
  serialize :fields

  class << self
    def get
      Record.new first
    end

    def update
      row = first || new
      updater = Updater.new
      row.date = updater.date
      row.fields = updater.fields
      row.save
    end
  end

  class Record
    def initialize(record)
      @record = record
    end

    def date
      @record.date
    end

    def value(key)
      if @record.fields[key] && @record.fields[key][:value]
        @record.fields[key][:value]
      else
        nil
      end
    end
  end

  class Updater
    URL = 'http://www.cbr.ru/scripts/XML_daily.asp'
    attr_reader :date, :fields

    def initialize
      @date = nil
      @fields = {}
      load_data
    end

    private

    def load_data
      url = URI.parse URL
      respond = Net::HTTP.get url
      doc = Hpricot::XML(respond)
      parse_data(doc)
    end

    def parse_data(doc)
      @date = Date.parse doc.at(:ValCurs)[:Date]
      (doc/'ValCurs/Valute').each do |valute|
        code = (valute/:CharCode).html.to_sym
        @fields[code] = {}
        @fields[code][:value] = (valute/:Value).html.gsub(',','.').to_f
      end
    end
  end
end
