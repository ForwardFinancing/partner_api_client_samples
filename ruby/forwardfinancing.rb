# To execute run:
# bundle install
# ruby forwardfinancing.rb

require 'json'
require 'httparty'
require 'base64'
require 'faker'

# Since you don't want to hard-code an api key, read it from environment var
api_key = ENV["FORWARD_FINANCING_API_KEY"]

json = {
  "lead" => {
    "contacts_attributes" => [
      {
        "first_name" => "#{Faker::Name.first_name}",
        "last_name" => "#{Faker::Name.last_name}",
        "email" => "#{Faker::Internet.email}",
        "title" => "#{Faker::Name.prefix}",
        "born_on" => "2015-01-01",
        "home_phone" => "6176781000",
        "cell_phone" => "6176781000",
        "ssn" => "234345566",
        "ownership_date" => "2015-01-01",
        "current_address_attributes" => {
          "street1" => "string",
          "street2" => "string",
          "city" => "string",
          "state" => "AK",
          "zip" => "00112"
        }
      }
    ],
    "account_attributes" => {
      "entity_type" => "Sole Proprietor",
      "name" => "string",
      "started_on" => "2015-01-01",
      "legal_name" => "string",
      "phone" => "6176781000",
      "email" => "test@forwardfinancing.com",
      "website" => "string",
      "fein" => "string",
      "monthly_revenue" => "Less than $5,000",
      "industry_name" => "Laundry and dry cleaning services",
      "current_address_attributes" => {
        "street1" => "string",
        "street2" => "string",
        "city" => "string",
        "state" => "AK",
        "zip" => "00112"
      }
    },
    "loan_attributes" => {
      "company_name" => "string",
      "daily_payment_amount" => 0,
      "balance" => 0
    },
    "application_attributes" => {
      "has_current_loan" => true,
      "applicant_is_owner" => true,
      "loan_use" => "Debt Refinancing",
      "capital_needed" => "string",
      "owner_1_percent_ownership" => 0,
      "owner_2_percent_ownership" => 0,
      "reference_id" => "#{Faker::Number.between(1, 100000000)}"
    }
  }
}.to_json

response = HTTParty.post(
  "https://api-staging.forwardfinancing.com/v1/lead",
  headers: {
    'api_key' => api_key,
    'Content-Type' => 'application/json'
  },
  body: json
)

# If the response was 201 it worked
if response.code == 201
  puts response.body
  lead_id = JSON.parse(response.body)['id']
  puts "Lead id: #{lead_id}"
else
  # If the response was not 200, something went wrong
  # The response body might have some info about what wrong in addition to the
  #   status code
  raise response.code
end

# Send an attachment

file_binary = File.open('./forwardfinancing.rb', 'rb').read

response = HTTParty.post(
  "https://api-staging.forwardfinancing.com/v1/attachment?lead_id=#{lead_id}&filename=test.txt",
  headers: {
    'api_key' => api_key
  },
  body: file_binary
)

puts response.body
if response.code == 202
  puts "It worked!"
end

# Send an attachment base64 encoded
file_string = Base64.strict_encode64(file_binary)

# Send the same request, only with the encoded=true url param and the encoded
# body
response = HTTParty.post(
  "https://api-staging.forwardfinancing.com/v1/attachment?lead_id=#{lead_id}&filename=test.txt&encoded=true",
  headers: {
    'api_key' => api_key
  },
  body: file_string
)

puts response.body
if response.code == 202
  puts "It worked!"
end
