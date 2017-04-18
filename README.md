# Problem Description

Create an Elixir web application that tracks sales information for different products. You are writing code that will 
contact a hypothetical vendor, Omega Pricing Inc -"The Last Word In Pricing"- to get new pricing information for several 
products. In your database, you have a products table that has:

* id
* external_product_id (which is the id that external vendors, such as Omega Pricing, uses)
* price (in pennies)
* product_name
* created_at timestamp
* updated_at timestamp

Each product may be associated with many `past_price` records, which is a separate table. A past price record is a record 
of what the price of something used to be at some point. This table has the following fields:

* id
* product_id (a foreign key to products)
* price (again in pennies)
* percentage_change, which is a float
* created_at timestamp
* updated_at timestamp

Your company will update these records monthly, and you are helping with the code that will make the RESTful calls to 
Omega Pricing's API.

Please write code that does the following:

1\. Makes a GET call to `https://omegapricinginc.com/pricing/records.json`  (this is simply a hypothetical vendor 
URL-please don't expect a real response) and passes the following as URL params:

* "abc123key" as yourapi_key
* start_date of one month ago
* end_date of today

2\. Parses the JSON response:

         
```json
{
  productRecords: 
    [
      {
        id: 123456,
        name: "Nice Chair",
        price: "$30.25",
        category: "home-furnishings",
        discontinued: false
      },
      {
        id: 234567,
        name: "Black & White TV",
        price: "$43.77",
        category: "electronics",
        discontinued: true
      }
    ]
}
```

3\. Updates the records based on the following logic:
 
* If you have a product with an external_product_id that matches their id and it has the same name and the price is 
  different, create a new past price record for your product. Then update the product's price. Do this even if the item 
  is discontinued.
* If you do not have a product with that external_product_id and the product is not discontinued, create a new product 
  record for it. Explicitly log that there is a new product and that you are creating a new product.
* If you have a product record with a matching external_product_id but a different product name, log an error message 
  that warns the team that there is a mismatch. Do not update the price. 
  
A Few Notes
* If you need to make any assumptions as you code, please record what they are. If you use any libraries to help, please 
  note what they are and how they helped with solving the problem.
* Tests are important, so please make sure your code is thoroughly tested.

# Implementation Notes

* Since the API we're trying to query doesn't really exist, going to figure out a way of stubbing those requests.

* Modules needed:
  - RetrieveMonthlyPricingData > returns the JSON
  - InsertRetrievedPricingDataJSON (takes JSON from RetrieveMonthlyPricingData)
  - UpdatePricingData - module that executes the overall process. should be the equivalent of a Rails rake task 
  
## Assumptions

* The data set returned by the Omega Pricing API is going to be small enough that it could be processed in a single
  API call. If it returned something like 5GB of data then you would have problems with the network and storing
  all that information into memory. I'm going to assume that when you query one month's worth of data it will be small
  enough to be retrieved in a few seconds and be a manageable size for this processing app's memory. In past projects
  I've downloaded data sets similar to this in Ruby which were thousands of records long and it still processed quickly.
* The spec did not state exactly how to "Explicitly log that there is a new product and that you are creating a new 
  product." I plan to do this by creating a new past_price record with a price_change value of nil.
  
## Libraries Used

* The Poison Elixir library is used throughout this program to convert and parse JSON.

## Mapping of Scenarios to Test


**We have external_product_id, same name, price is different**

* Create new past_price record
* Update the `products` table price
* <ignore the discontinued flag>

**We do not have external_product_id, product is not discontinued**

* Create new product
* Create past price record with price_change value of nil (see Assumptions section above) 

**We have external_product_id, different product name**

* If you have a product record with a matching external_product_id but a different product name, log an error message 
  that warns the team that there is a mismatch. Do not update the price. 



%{productRecords: [%{id: 123456,name: "Nice Chair",price: "$30.25",category: "home-furnishings",discontinued: false},%{id: 234567,name: "Black & White TV",price: "$43.77",category: "electronics",discontinued: true}] }

