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