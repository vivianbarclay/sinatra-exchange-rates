
require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

exchange_rate_base_url = "https://api.exchangerate.host"
exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")
exchange_rate_url =  "https://api.exchangerate.host/list?access_key=#{exchange_rate_key}"



currency_conversion_rate_url = "https://api.exchangerate.host/convert?from=USD&to=INR&amount=1&access_key=#{exchange_rate_key}"
raw_currency_conversion_rate = HTTP.get(currency_conversion_rate_url)
parsed_conversion_data = JSON.parse(raw_currency_conversion_rate)

pp parsed_conversion_data  




#Homepage - List of Currencies
get("/") do
  raw_exchange_rate_url = HTTP.get(exchange_rate_url)
  parsed_exchange_rate = JSON.parse(raw_exchange_rate_url)

  if parsed_exchange_rate.fetch("success") == true
    @currencies = parsed_exchange_rate.fetch("currencies")
  else
    @currencies = []
  end

  erb( :index, {:layout => :layout}) 
end

# Convert Currency Page
 get("/:currency") do
   currency = params[:currency]

  raw_exchange_rate_url = HTTP.get(exchange_rate_url)
  parsed_exchange_rate = JSON.parse(raw_exchange_rate_url)

  if parsed_exchange_rate.fetch("success") == true
    @currencies = parsed_exchange_rate.fetch("currencies")
  else
    @currencies = []
  end

  erb( :convert_currency, {:locals => {:currency => currency} }, {:layout => :layout} )
end

#Currency to Currency Conversion Page
get("/:currency_1/:currency_2") do
  currency_1 = params[:currency_1]
  currency_2 = params[:currency_2]

  currency_conversion_rate_url = "https://api.exchangerate.host/convert?from=#{currency_1}&to=#{currency_2}&amount=1&access_key=#{exchange_rate_key}"
  raw_currency_conversion_rate = HTTP.get(currency_conversion_rate_url)
  parsed_conversion_data = JSON.parse(raw_currency_conversion_rate)

  if parsed_conversion_data.fetch("success") == true
    rate = parsed_conversion_data.fetch("result")
  else
    rate = nil
  end

  erb(:conversion, { :locals => {:currency_1 => currency_1, :currency_2 => currency_2, :rate => rate}}, {:layout => :layout})

end
