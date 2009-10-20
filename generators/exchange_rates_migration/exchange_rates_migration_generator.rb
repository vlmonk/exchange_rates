class ExchangeRatesMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'model:migration.rb', 'db/migrate', {
        :migration_file_name => 'create_exchange_rates',
        :assigns => assigns
      }
    end
  end

  private

  def assigns
    returning assigns={} do
      assigns[:migration_name] = 'CreateExchangeRates'
      assigns[:table_name] = 'exchange_rates'
      assigns[:attributes] = []
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new('date', 'date')
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new('fields', 'text')
    end
  end
end
