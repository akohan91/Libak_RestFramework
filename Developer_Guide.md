# Demo of usage

```java
@RestResource(UrlMapping='/*/accounts/*')
global with sharing class DemoRestFramework {

	@HttpGet
	global static void doGet() {
		RestFramework.handleRequest(AccountRestRouter.class);
	}
	@HttpPost
	global static void doPost() {
		RestFramework.handleRequest(AccountRestRouter.class);
	}
	@HttpPut
	global static void doPut() {
		RestFramework.handleRequest(AccountRestRouter.class);
	}
	@HttpDelete
	global static void doDelete() {
		RestFramework.handleRequest(AccountRestRouter.class);
	}

	public class AccountRestRouter extends RestRouter {
		override public RestRouter setRoutes() {
			this.routeToRestProcessorType = new Map<String, Type>{
				'/v1/accounts' => AccountProcessorV1.class,
				'/v1/accounts/:accountId' => AccountProcessorV1.class,
				'/v2/accounts' => AccountProcessorV2.class,
				'/v2/accounts/:accountId' => AccountProcessorV2.class
			};
			return this;
		}
	}

	public virtual with sharing class AccountProcessorV1 extends RestProcessor {
		protected virtual override RestFramework.IRestResponse handleGet() {
			String accountId = this.getUriParam('accountId');
			List<Account> accounts = [SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE Id = :accountId];

			if (accounts != null && !accounts.isEmpty()) {
				return new JsonResponse(accounts.get(0));
			} else {
				throw new RestFramework.NotFoundException('Account not found');
			}
		}

		protected override RestFramework.IRestResponse handlePost() {
			Account newAccount = (Account)JSON.deserialize(this.request.requestBody.toString(), Account.class);
			insert newAccount;

			return new JsonResponse(newAccount);
		}

		protected override RestFramework.IRestResponse handlePut() {
			String accountId = this.getUriParam('accountId');
			List<Account> existingAccounts = [SELECT Id FROM Account WHERE Id = :accountId];

			if (!existingAccounts.isEmpty()) {
				Account updatedAccount = (Account)JSON.deserialize(this.request.requestBody.toString(), Account.class);
				updatedAccount.Id = accountId;
				update updatedAccount;

				return new JsonResponse(updatedAccount);
			} else {
				throw new RestFramework.NotFoundException('Account not found');
			}
		}

		protected override RestFramework.IRestResponse handleDelete() {
			String accountId = this.getUriParam('accountId');
			List<Account> existingAccounts = [SELECT Id FROM Account WHERE Id = :accountId];

			if (!existingAccounts.isEmpty()) {
				delete existingAccounts.get(0);

				return new SuccessResponse('Account deleted successfully');
			} else {
				throw new RestFramework.NotFoundException('Account not found');
			}
		}
	}

	public with sharing class AccountProcessorV2 extends AccountProcessorV1 {
		protected override RestFramework.IRestResponse handleGet() {
			String accId = this.getUriParam('accountId');
			if (String.isBlank(accId)) {
				Integer limitNumber = this.request.params.containsKey('limit') ? Integer.valueOf(this.request.params.get('limit')) : 10;
				Integer offsetNumber = this.request.params.containsKey('offset') ? Integer.valueOf(this.request.params.get('offset')) : 0;
				return this.getAccounts(limitNumber, offsetNumber);
			} else {
				return this.getAccountById(accId);
			}
		}

		private RestFramework.IRestResponse getAccountById(String accId) {
			List<Account> accounts = [SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE Id = :accId];

			if (!accounts.isEmpty()) {
				return new JsonResponse(accounts.get(0));
			} else {
				throw new RestFramework.NotFoundException('No accounts found');
			}
		}

		private RestFramework.IRestResponse getAccounts(Integer limitNumber, Integer offsetNumber) {
			List<Account> accounts = [SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account LIMIT :limitNumber OFFSET :offsetNumber];

			if (!accounts.isEmpty()) {
				return new JsonResponse(accounts);
			} else {
				throw new RestFramework.NotFoundException('No accounts found');
			}
		}
	}
}
```