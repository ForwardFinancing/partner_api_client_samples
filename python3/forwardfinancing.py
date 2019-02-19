import requests
import os
import json
import base64

# Since you don't want to hard-code an api key, read it from environment var
api_key = os.environ["FORWARD_FINANCING_API_KEY"]

# sample payload
body = {
  "lead": {
    "contacts_attributes": [
      {
        "first_name": "string",
        "last_name": "string",
        "email": "test@forwardfinancing.com",
        "title": "string",
        "born_on": "2015-01-01",
        "home_phone": "6176781000",
        "cell_phone": "6176781000",
        "ssn": "234345566",
        "ownership_date": "2015-01-01",
        "current_address_attributes": {
          "street1": "string",
          "street2": "string",
          "city": "string",
          "state": "AK",
          "zip": "00112"
        }
      }
    ],
    "account_attributes": {
      "entity_type": "Sole Proprietor",
      "name": "string",
      "started_on": "2015-01-01",
      "legal_name": "string",
      "phone": "6176781000",
      "email": "test@forwardfinancing.com",
      "website": "string",
      "fein": "string",
      "monthly_revenue": "Less than $5,000",
      "industry_name": "Laundry and dry cleaning services",
      "current_address_attributes": {
        "street1": "string",
        "street2": "string",
        "city": "string",
        "state": "AK",
        "zip": "00112"
      }
    },
    "loan_attributes": {
      "company_name": "string",
      "daily_payment_amount": 0,
      "balance": 0
    },
    "application_attributes": {
      "has_current_loan": True,
      "applicant_is_owner": True,
      "loan_use": "Debt Refinancing",
      "capital_needed": "10000",
      "owner_1_percent_ownership": 0,
      "owner_2_percent_ownership": 0,
      "reference_id": "unique_string_here"
    }
  }
}

# Send your api_key in in the header
# Make sure to specify the Content-Type for the /lead endpoint!
headers = {
    "api_key": api_key,
    "Content-Type": "application/json"
}

print(json.dumps(body, indent=4))

response = requests.post("https://api-staging.forwardfinancing.com/v1/lead", headers=headers, data=json.dumps(body))

# If the response was 201 it worked
if response.status_code == 201:
    print(response.json())
    lead_id = response.json()["id"]
    print("Lead id: ", lead_id)
else:
    # If the response was not 200, something went wrong
    # The response body might have some info about what wrong in addition to the
    # status code
    print(response.status_code, " - Error")

# Send an attachment
with open("forwardfinancing.py", "rb") as file_binary:
    response = requests.post("https://api-staging.forwardfinancing.com/v1/attachment?lead_id={0}&filename=test.txt".format(lead_id),
        headers={"api_key": api_key},
        data=file_binary
    )
    print(response.json())

    if response.status_code == 202:
        print("It worked!")

with open("forwardfinancing.py", "rb") as file_binary:
    # Send an attachment base64 encoded
    file_string = base64.b64encode(file_binary.read())
    
    # Send the same request, only with the encoded=true url param and the encoded
    # body
    response = requests.post("https://api-staging.forwardfinancing.com/v1/attachment?lead_id={0}&filename=test.txt&encoded=true".format(lead_id),
        headers={"api_key": api_key},
        data=file_string
    )

    print(response.json())

    if response.status_code == 202:
        print("It worked!")
