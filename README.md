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

* Since the API we're trying to query doesn't really exist, will have to rely on just the test suite and stubbing
  of data to demonstrate how this works.

* Decided to layer the internal workflow among the following modules and respective functionality:
  - OmegaClient.FetchMonthlyPrices.xxxx - the low level module that makes the web request and returns the received JSON.
    This is the part of the system that will be stubbed with a test version for running the test suite. 
  - RetrieveMonthlyPricingData - initiates the former, manages the whole process and defers to UpdatePrice. If we were
    to have a job running that occasionally initiates the process of updating our database, it would call this function. 
  - UpdatePrices - takes a line item of pricing data and runs the logic specified from step #3 
  
## Mapping of Scenarios in Requirement #3

**3a. We have external_product_id, same name, price is different**

* Create new past_price record
* Update the `products` table price
* <ignore the discontinued flag>

**3b. We do not have external_product_id, product is not discontinued**

* Create new product
* Create past price record with price_change value of nil (see Assumptions section above) 

**3c. We have external_product_id, different product name**

* If you have a product record with a matching external_product_id but a different product name, log an error message 
  that warns the team that there is a mismatch. Do not update the price. 

## Assumptions

* The data set returned by the Omega Pricing API is going to be small enough that it could be processed in a single
  API call. If it returned something like 5GB of data then you would have problems with the network and storing
  all that information into memory. I'm going to assume that when you query one month's worth of data it will be small
  enough to be retrieved in a few seconds and be a manageable size for this processing app's memory. In past projects
  I've downloaded data sets similar to this in Ruby which were thousands of records long and it still processed quickly.
* The spec did not state exactly how to "Explicitly log that there is a new product and that you are creating a new 
  product." I plan to do this by creating a new past_price record with a price_change value of nil.
* Regarding how to log errors, I asked the "product owner" the expectation on how this is to be done. Received the
  following response. Given that, I'm just going to print messages to STDOUT and not worry about the distinction of 
  STDERR. 
  
> The word "log" in the task should be taken to mean log a message to standard error or standard out.
> You can work under the assumption that a collector outside the app would be gathering these logs and shipping them
> somewhere useful. 
> If you want to make a note in the README about the assumption or how you might approach it in a production scenario (as you have above) that's more than welcome too.
  
* Going to assume that the API takes date values in the format 'YYYY-MM-DD' for the simplicity of making the conversions
  easy.
* One thing I notice about the past price information example is that the JSON returned lacks a "price_date", which is 
  often returned by similar APIs. I find it odd that the parameters to be sent include a start and end date, but a date
  is not returned by the API. What if the price changed multiple times in the given time frame? 

  
## Libraries Used

* The Poison Elixir library is used throughout this program to convert and parse JSON.
* HTTPoison is used to handle the web API calls.
* ~~Mock library to handle mocking of API calls in the test environment.~~ Originally was going to mock the API call, but
  learned that in Elixir mocks are discouraged.
* Timex used for handling dates


## Things I'm Still Figuring Out & Want to Improve

### How to Test the HTTP Calls

In Ruby it's common to mock web requests using a library like Webmock, which at the system level manipulates the data
being returned by calls to the Internet. [The Elixir paradigm is different in that its preferred to isolate any subsystem
that calls the internet into its own module.](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/)

In Ruby I probably would have made a `FetchMonthlyPrices` interactor class that retrieves the data via HTTP, and use 
Webmock to have the API call to the Internet return some fixture data. In Elixir, the recommended way of doing it
is to abstract the part of the system that sends the web request and use an environment variable to change it out
to a "mock" version for testing, and use the actual HTTP version in production/development. The commonly cited
Platformatec blog post which demonstrates how to do this recommends using a Behavior (similar to a Java interface) to
define the FetchMonthlyPrices class and build the HTTP and mock implementations off of that.

I dislike this approach because it leaves the HTTP client (where the rubber meets the road) largely untested.
The Platformatec blog author suggests making a separate test for the HTTP client that runs conditionally and 
deliberately. 

> Personally, I would test MyApp.Twitter.HTTP by directly reaching the Twitter API. We would run those tests only when 
> needed in development and configure them as necessary in our build system. The @tag system in ExUnit, Elixir’s test 
> library, provides conveniences to help us with that...

For this sample project I couldn't perform that test because the Omega Pricing API doesn't exist irl. Also, I don't know
yet whether the Mock version of the fixture should be in `lib` next to the HTTP version of the client, or somewhere
in the test folder because it's used in the test environment.

### Validation of Data / Error Handling

There are a lot of areas where something could go wrong with the system such as a bad API response, problem with the
database, sometimes you get bad data types back from the API, etc. For this project I kind of assumed that the 
underlying technologies were stable. However, if I were to work on this longer I would identify areas where errors
could occur (such as getting an :error response from Ecto) and make the appropriate contingency handling code.
When working in Ruby I often use rescue blocks to cleanly handle errors, sometimes using that to make an error message
more meaningful if I know the specific cause of the issue.

### Test Coverage

Starting with the mocking of the web request, I was surprised to find that the test paradigms in Elixir are different
in some ways from Ruby on Rails. In Rails I'm used to making mocks and more elaborate fixtures in RSpec. From a syntax
standpoint, some of the ideas such as how test data is set up is different. In RSpec I use the `let` and `before`
blocks frequently, but Elixir has its own parallel using `context` and `setup`. Getting in sync with the Elixir
way of thinking to make test inputs was challenging and I think will take more time for me to perfect.

I know the paradigm in Elixir is to use smaller chunks of data to test, but for convenience I included all of the conditions
in requirement #3 (the update rules for past prices) in a single test for UpdatePrices. It might be a good idea
to break down the test into smaller fixtures and have a separate test of each business case.  

### Namespacing

I'm still a little rough on `import` vs `use` in figuring out how namespaces are typically handled. Still finding
my way around contextually in the best way to include needed modules for tests.

### Problems with the package manager

Elixir's use of versioning seems less sophisticated and more error prone than Ruby bundler. I've installed Elixir using
`brew` but this seems to be what most people in the community do vs using a tool like `rvm`. I can't imagine how
this doesn't cause aggravating problems with version inconsistencies. I ran into the following
error message when trying some tutorials from the Github [phoenix-examples](https://github.com/phoenix-examples):

```
== Compilation error on file web/router.ex ==
** (CompileError) web/router.ex: internal error in v3_core;
crash reason: {case_clause,
    {'EXIT',
        {badarg,
            [{erl_anno,anno_info,[-1],[{file,"erl_anno.erl"},{line,360}]},
             {v3_core,record_anno,2,[{file,"v3_core.erl"},{line,2410}]},
             {v3_core,expr,2,[{file,"v3_core.erl"},{line,539}]},
             {v3_core,safe,2,[{file,"v3_core.erl"},{line,1593}]},
             {v3_core,expr,2,[{file,"v3_core.erl"},{line,528}]},
             {v3_core,safe,2,[{file,"v3_core.erl"},{line,1593}]},
             {v3_core,'-safe_list/2-anonymous-0-',2,
                 [{file,"v3_core.erl"},{line,1608}]},
             {lists,foldr,3,[{file,"lists.erl"},{line,1276}]}]}}}

  in function  compile:'-select_passes/2-anonymous-2-'/2 (compile.erl, line 544)
  in call from compile:'-internal_comp/4-anonymous-1-'/2 (compile.erl, line 329)
  in call from compile:fold_comp/3 (compile.erl, line 355)
  in call from compile:internal_comp/4 (compile.erl, line 339)
  in call from compile:'-do_compile/2-anonymous-0-'/2 (compile.erl, line 177)
  in call from compile:'-do_compile/2-anonymous-1-'/1 (compile.erl, line 190)
    (stdlib) lists.erl:1338: :lists.foreach/2
    (phoenix) expanding macro: Phoenix.Router.__before_compile__/1
    web/router.ex:1: SprintPoker.Router (module)
```