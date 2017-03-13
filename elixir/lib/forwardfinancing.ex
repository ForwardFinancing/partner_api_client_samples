defmodule ForwardFinancing do
  def api_example do

    # Read the API key from an environment variable
    api_key = System.get_env("FORWARD_FINANCING_API_KEY")

    json_data = %{
      lead: %{
        contacts_attributes: [
          %{
            "first_name" => "string",
            "last_name" => "string",
            "email" => "test@forwardfinancing.com",
            "title" => "string",
            "born_on" => "2015-01-01",
            "home_phone" => "6176781000",
            "cell_phone" => "6176781000",
            "ssn" => "234345566",
            "ownership_date" => "2015-01-01",
            current_address_attributes:  %{
              "street1" => "string",
              "street2" => "string",
              "city" => "string",
              "state" => "AK",
              "zip" => "00112"
            }
          }
        ],
        account_attributes: %{
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
          current_address_attributes: %{
            "street1" => "string",
            "street2" => "string",
            "city" => "string",
            "state" => "AK",
            "zip" => "00112"
          }
        },
        loan_attributes:  %{
          "company_name" => "string",
          "daily_payment_amount" => 0,
          "balance" => 0
        },
        application_attributes: %{
          "has_current_loan" => true,
          "applicant_is_owner" => true,
          "loan_use" => "Debt Refinancing",
          "capital_needed" => "string",
          "owner_1_percent_ownership" => 0,
          "owner_2_percent_ownership" => 0,
          "reference_id" => "string"
        }
      }
    }

    # Encode the map in json
    json = json_data |> Poison.encode!

    # Send a lead
    response = HTTPoison.post!(
      "https://api-staging.forwardfinancing.com/v1/lead",
      headers: %{
        "api_key" => api_key,
        "Content-Type" => "application/json"
      },
      body: json
    )

    if response.status_code == 201 do
      IO.puts response.body
      lead_id = response.body |> Poison.decode! |> Map.get("id")
      IO.puts "Lead id: #{lead_id}"
    else
      # Something went wrong
      IO.puts response.status_code
    end


    # Send an attachment for the lead
    file_binary = File.read!("forwardfinancing.ex")

    response = HTTPoison.post!(
      "https://api-staging.forwardfinancing.com/v1/attachment?lead_id=#{lead_id}&filename=test.txt",
      headers: %{
        "api_key" => api_key
      },
      body: file_binary
    )

    if response.status_code == 202 do
      IO.puts "It worked!"
    end


    # Send an encoded attachment
    file_string = file_binary |> Base.encode64
    response = HTTPoison.post!(
      "https://api-staging.forwardfinancing.com/v1/attachment?lead_id=#{lead_id}&filename=test.txt&encoded=true",
      headers: %{
        "api_key" => api_key
      },
      body: file_string
    )

    if response.status_code == 202 do
      IO.puts "It worked!"
    end
  end
end
