class ExchangeRates
  module ViewHelpers
    def exchange_rates &block
      rates = ExchangeRates.get
      yield rates 
    end
  end
end

ActionView::Base.send :include, ExchangeRates::ViewHelpers
