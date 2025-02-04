
require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

exchange_rate_base_url = "https://api.exchangerate.host"
exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")
exchange_rate_url =  "https://api.exchangerate.host/list?access_key=#{exchange_rate_key}"

# raw_exchange_rate_url = HTTP.get(exchange_rate_url)
# parsed_exchange_rate = JSON.parse(raw_exchange_rate_url)

# check_success = parsed_exchange_rate.fetch("success")
# pp check_success.class
# @currencies = parsed_exchange_rate.fetch["currencies"]


#Homepage - List of Currencies
get("/") do
  raw_exchange_rate_url = HTTP.get(exchange_rate_url)
  parsed_exchange_rate = JSON.parse(raw_exchange_rate_url)

  if parsed_exchange_rate.fetch("success") == true
    @currencies = parsed_exchange_rate.fetch("currencies")
  else
    @currencies = []
  end

  erb :index
end

# # Conversion Page
# get("/:currency") do
#   @currency = params[:currency]

#   uri = URI("#{API_BASE_URL}/latest?base=#{@currency}")
#   response = Net::HTTP.get(uri)
#   data = JSON.parse(response)

#   puts data

#   if data["success"]
#     @rates = data["rates"]
#   else
#     @rates = {}
#   end

#   erb :convert
# end
