module ExchangeRatesHelper
  def exchange_rates &block
    rates = ExchangeRates.get
    yield rates 
  end
end

ActionView::Base.send :include, ExchangeRatesHelper
