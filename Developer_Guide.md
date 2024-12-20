# REST Framework Developer Guide

## Key Components

- **Routing**: Define routes for handling REST API requests.
- **Response Handling**: Create structured responses for successful and error cases.
- **Error Management**: Handle exceptions with custom error responses.
- **Logging**: Log details of RESTful operations.

## Step 1: Setup

### Prerequisites

- **Salesforce Developer Environment**: Ensure you have access to a Salesforce org.
- **Code Editor**: Use the Salesforce Developer Console or an IDE like VS Code with the Salesforce Extension Pack.

### Installation

1. Clone or download the `libak_RestFramework` source code from the repository.
2. Deploy the framework classes to your Salesforce org using a deployment tool like Salesforce CLI or an IDE.

## Step 1.1. Implementation Overview

Through this guide, we will prepare a classic implementation of a web service to manage CRUD operations, showcasing the functionality of the REST Framework.

### Goal

Build a service called `customers`

#### Requirements
1. Versioning Support
2. CRUD Operations
	- Retrieve a list of customers: GET `<version>/customers`
	- Implement pagination: GET `<version>/customers?page=<page_number>&pageSize=<page_size>`
	- Retrieve a customer by ID: GET `<version>/customers/<customer_sf_id>`
	- Create a new customer: POST `<version>/customers` with JSON payload
	- Update a customer: PUT `<version>/customers/<customer_sf_id>` with JSON payload
	- Delete a customer: DELETE `<version>/customers/<customer_sf_id>`

## Step 2: Define a Salesforce Web Service Class

Create a new Salesforce web service class as the entry point:

```java
@RestResource(UrlMapping='/*/customer/*')
global with sharing class CustomerWebServiceDemo {
	@HttpGet
	global static void doGet() {
		
	}
	@HttpPost
	global static void doPost() {
		
	}
	@HttpPut
	global static void doPut() {
		
	}
	@HttpDelete
	global static void doDelete() {
		
	}
}
```

At this step we have to specify the UrlMapping in a proper format.
- UrlMapping: `/*/customer/*` allows:
	- The first `*` for versioning.
	- The second `*` for path-specific operations.

<blockquote>
<b>NOTE:</b> Notice we set the `UrlMapping` as `/*/customer/*` to handle the `customers` web service where the first `*` is reserved for versioning and the second one for the rest of paths.

Technically it's possible to set the `UrlMapping` as `/*` and handle all the requests using the `libak_RestRouter` but we recommend to create a dedicated web service class for each service like: `customers`, `products`, etc. to simplify managing them.
</blockquote>

## Step 3: Define a Rest Router

Now is time to thing about routing.
Analyzing our requirements we can define two routes:

- **`v1/customers`**: the route will be used to retrieve list of our customers and create new.
- **`v1/customers/:customer_id`**: the route will be used for manipulations on the dedicated customer. Here you can see the colon character `:` before the `customer_id`. This way we mark a named URI params that we can easily get access to in the Rest Processor (look at Step 4 for details).

To create a RestRouter we have to extend the `libak_RestRouter` class and override the `setRoutes()` method where we have to specify which Rest Processor we handle which route by setting the `routeToRestProcessorType` protected property as `<route>:<libak_RestProcessor type>`.

Let's create it:

```java
public class CustomerRestRouter extends libak_RestRouter {
	override public libak_RestRouter setRoutes() {
		this.routeToRestProcessorType = new Map<String, Type>{
			'/v1/customers' => CustomersProcessorV1.class,
			'/v1/customers/:customer_sf_id' => CustomerProcessorV1.class
		};
		return this;
	}
}
```
As a result we have two routes that will handle two Rest Processors which we'll create on the next step.

> **_NOTE:_** In our implementation we will use two independent services to handle two routes but it's also possible to use the only Rest Processor for all routes. It's up to you how you organize your application but the REST Framework provides this flexibility and you just have to decide.

```java
// The REST Router implementation when all routes are handled by one REST Processor.
public class CustomerRestRouter extends libak_RestRouter {
	override public libak_RestRouter setRoutes() {
		this.routeToRestProcessorType = new Map<String, Type>{
			'/v1/customers' => CustomersProcessorV1.class,
			'/v1/customers/:customer_sf_id' => CustomersProcessorV1.class
		};
		return this;
	}
}
```

> **_NOTE:_** We recommend to put Rest Router as an inner class in our `CustomerWebServiceDemo` class to have clear view of our API when the developer opens the web service class.

At this point the `CustomerWebServiceDemo` class looks like this:

```java
@RestResource(UrlMapping='/*/customer/*')
global with sharing class CustomerWebServiceDemo {
	@HttpGet
	global static void doGet() {
		
	}
	@HttpPost
	global static void doPost() {
		
	}
	@HttpPut
	global static void doPut() {
		
	}
	@HttpDelete
	global static void doDelete() {
		
	}

	public class CustomerRestRouter extends libak_RestRouter {
		override public libak_RestRouter setRoutes() {
			this.routeToRestProcessorType = new Map<String, Type>{
				'/v1/customers' => CustomersProcessorV1.class,
				'/v1/customers/:customer_sf_id' => CustomerProcessorV1.class
			};
			return this;
		}
	}
}
```

## Step 4: Define a Rest Processor

Well, We've already done a good job to implement a base version of building our customer web service.

Now it's time to implement our REST Processors.

As you remember we agreed to have two of them:
- `CustomersProcessorV1` for `/v1/customers`
- `CustomerProcessorV1` for `/v1/customers/:customer_sf_id`

Here is a few things you have to consider about it:
- Our rest processors have to `extend` the `libak_RestProcessor`
- the `libak_RestProcessor` provides set of methods to handle the HTTP methods that you have to override if needed otherwise the REST Processor will respond with the `405` HTTP code -> 'HTTP Method is not allowed':
	- GET -> handleGet()
	- POST -> handlePost()
	- PUT -> handlePut()
	- PATCH -> handlePatch()
	- DELETE -> handleDelete()
	
	All these methods have to return the `libak_RestFramework.IRestResponse`.
- the `libak_RestProcessor` provides set of methods to easily get access to URI params, query params, and headers:
	- `getUriParam(String paramName)` - remember about the colon character `:` we saw in the routes? It allows us to use those "variable" names to take the proper URI param like this: `this.getUriParam('customer_sf_id')`
	- `getQueryParam(String paramName)`
	- `getHeader(String headerName)`

Now we know good enough at this stage to prepare our Rest Processors

```java
// Here you can see there is no pagination implementation. We will add it later to show the versioning functionality.
public class CustomersProcessorV1 extends libak_RestProcessor {
	protected override libak_RestFramework.IRestResponse handleGet() {
		List<Account> accounts = [
			SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
			FROM Account
			LIMIT 100
		];

		if (accounts.isEmpty()) {
			return new libak_ErrorResponse(404, 'Accounts are not found', '');
		} else {
			return new libak_JsonResponse(accounts);
		}
	}

	protected override libak_RestFramework.IRestResponse handlePost() {
		Account newAccount = (Account)JSON.deserialize(this.request.requestBody.toString(), Account.class);
		insert newAccount;

		return new libak_JsonResponse(newAccount);
	}
}
```

```java
public class CustomerProcessorV1 extends libak_RestProcessor {
	protected override libak_RestFramework.IRestResponse handleGet() {
		List<Account> accounts = [
			SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
			FROM Account
			WHERE Id = :this.getUriParam('customer_sf_id')
		];

		if (accounts.isEmpty()) {
			return new libak_ErrorResponse(404, 'Accounts are not found', '');
		} else {
			return new libak_JsonResponse(accounts.get(0));
		}
	}

	protected override libak_RestFramework.IRestResponse handlePut() {
		String accountId = this.getUriParam('customer_sf_id');
		List<Account> existingAccounts = [SELECT Id FROM Account WHERE Id = :accountId];

		if (existingAccounts.isEmpty()) {
			return new libak_ErrorResponse(404, 'Account are not found', '');
		}

		Account updatedAccount = (Account)JSON.deserialize(this.request.requestBody.toString(), Account.class);
		updatedAccount.Id = accountId;
		update updatedAccount;
		return new libak_JsonResponse(updatedAccount);
	}

	protected override libak_RestFramework.IRestResponse handleDelete() {
		String accountId = this.getUriParam('customer_sf_id');
		List<Account> existingAccounts = [SELECT Id FROM Account WHERE Id = :accountId];

		if (existingAccounts.isEmpty()) {
			return new libak_ErrorResponse(404, 'Account are not found', '');
		}

		delete existingAccounts.get(0);
		return new libak_SuccessResponse('Account deleted successfully');
	}
}
```

## Step 5: Almost done

We have good news for you we have almost everything to make our web service workable.

The only thing which should be done is to execute our logic in the `@HttpGet`, `@HttpPost`, `@HttpPut`, and `@HttpDelete` methods of the `CustomerWebServiceDemo` class.

For this purpose there are a few static methods:
- `handleRequest(Type routerType)`
- `handleRequest(Type routerType, Type loggerType)`
- `handleRequest(Type routerType, Type loggerType, Type errorResponseFactoryType)`

At the moment for base implementation we will use the first one `handleRequest(Type routerType)` and others will be covered in the "Advanced Topics" section.

All that we have to do is to call the method in each of `@Http*` methods putting as a parameter the Type of our `CustomerRestRouter`.

Here is a full version of our web service:

```java
@RestResource(UrlMapping='/*/customers/*')
global with sharing class CustomerWebServiceDemo {
	@HttpGet
	global static void doGet() {
		libak_RestFramework.handleRequest(CustomerRestRouter.class);
	}
	@HttpPost
	global static void doPost() {
		libak_RestFramework.handleRequest(CustomerRestRouter.class);
	}
	@HttpPut
	global static void doPut() {
		libak_RestFramework.handleRequest(CustomerRestRouter.class);
	}
	@HttpDelete
	global static void doDelete() {
		libak_RestFramework.handleRequest(CustomerRestRouter.class);
	}

	public class CustomerRestRouter extends libak_RestRouter {
		override public libak_RestRouter setRoutes() {
			this.routeToRestProcessorType = new Map<String, Type>{
				'/v1/customers' => CustomersProcessorV1.class,
				'/v1/customers/:customer_sf_id' => CustomerProcessorV1.class
			};
			return this;
		}
	}

	public class CustomersProcessorV1 extends libak_RestProcessor {
		protected override libak_RestFramework.IRestResponse handleGet() {
			List<Account> accounts = [
				SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
				FROM Account
				LIMIT 100
			];

			if (accounts.isEmpty()) {
				return new libak_ErrorResponse(404, 'Accounts are not found', '');
			} else {
				return new libak_JsonResponse(accounts);
			}
		}

		protected override libak_RestFramework.IRestResponse handlePost() {
			Account newAccount = (Account)JSON.deserialize(this.request.requestBody.toString(), Account.class);
			insert newAccount;

			return new libak_JsonResponse(newAccount);
		}
	}

	public class CustomerProcessorV1 extends libak_RestProcessor {
		protected override libak_RestFramework.IRestResponse handleGet() {
			List<Account> accounts = [
				SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
				FROM Account
				WHERE Id = :this.getUriParam('customer_sf_id')
			];

			if (accounts.isEmpty()) {
				return new libak_ErrorResponse(404, 'Accounts are not found', '');
			} else {
				return new libak_JsonResponse(accounts.get(0));
			}
		}

		protected override libak_RestFramework.IRestResponse handlePut() {
			String accountId = this.getUriParam('customer_sf_id');
			List<Account> existingAccounts = [SELECT Id FROM Account WHERE Id = :accountId];

			if (existingAccounts.isEmpty()) {
				return new libak_ErrorResponse(404, 'Account are not found', '');
			}

			Account updatedAccount = (Account)JSON.deserialize(this.request.requestBody.toString(), Account.class);
			updatedAccount.Id = accountId;
			update updatedAccount;
			return new libak_JsonResponse(updatedAccount);
		}

		protected override libak_RestFramework.IRestResponse handleDelete() {
			String accountId = this.getUriParam('customer_sf_id');
			List<Account> existingAccounts = [SELECT Id FROM Account WHERE Id = :accountId];

			if (existingAccounts.isEmpty()) {
				return new libak_ErrorResponse(404, 'Account are not found', '');
			}

			delete existingAccounts.get(0);
			return new libak_SuccessResponse('Account deleted successfully');
		}
	}
}
```

> **_NOTE:_** In this example We've put the rest processors as a subclasses in owr web service just to simplify reading the code but feel free to keep them as independent classes.

# Advanced Topics