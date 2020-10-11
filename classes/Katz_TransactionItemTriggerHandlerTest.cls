/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : Test class for TransactionItem Trigger
 **/

@IsTest
public class Katz_TransactionItemTriggerHandlerTest {

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Unit test scenario when transactionItem API is supposed to be called and is successful
     * @param nonce
     */
    @IsTest
    public static void testTransactionItemAPIPositive() {
        Test.setMock(HttpCalloutMock.class, new Katz_TransactionAPIsHttpMock('SUCCESS'));
        Transaction__c objTransaction = Katz_TestDataFactory.createTransactions(3, 1, true)[0];
        Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 2, true);

        //Data assert
        List<Transaction__c> transactions = [SELECT Id, (Select Id FROM TransactionItem__r) FROM Transaction__c];
        System.assertEquals(1, transactions.size(),'There should be only 1 transaction in the system at this moment');
        System.assertEquals(2, transactions[0].TransactionItem__r.size(),'There should be only 2 transaction items under this transaction');

        //Begin Test execution
        Test.startTest();
        TransactionItem__c transactionItem = Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 1, true)[0];
        Test.stopTest();

        //Functionality Assert
        String indentifierForLogs = '%' + objTransaction.Id + '%';
        List<Integration_Logs__c> integrationLogs = [SELECT Id,Response_code__c,Integration_URL__c FROM Integration_Logs__c WHERE Identifier__c Like :indentifierForLogs];
        List<Transaction__c> transactionsAfterTest = [SELECT Transaction_Count__c,Number_of_Transaction_Items_in_SF__c FROM Transaction__c WHERE Id = :objTransaction.Id];
        System.assertEquals(transactionsAfterTest[0].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on Transaction');
        System.assertEquals(1, integrationLogs.size(),'There should be 1 integration log created after the integration');
        System.assertEquals('200', integrationLogs[0].Response_code__c,'The response code for this unit test should be 200');
        System.assertEquals(true, integrationLogs[0].Integration_URL__c.contains('callout:DUMMY_API'),'The integration log should be created from the dummy API');
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Unit test scenario when transactionItem API is not supposed to be called
     * @param nonce
     */
    @IsTest
    public static void testTransactionItemAPINegative() {
        Transaction__c objTransaction = Katz_TestDataFactory.createTransactions(4, 1, true)[0];
        Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 2, true);

        //Data assert
        List<Transaction__c> transactions = [SELECT Id, (Select Id FROM TransactionItem__r) FROM Transaction__c];
        System.assertEquals(1, transactions.size(),'There should be only 1 transaction in the system at this moment');
        System.assertEquals(2, transactions[0].TransactionItem__r.size(),'There should be only 2 transaction items under this transaction');

        //Begin Test execution
        Test.startTest();
        TransactionItem__c transactionItem = Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 1, true)[0];
        Test.stopTest();

        //Functionality Assert
        String indentifierForLogs = '%' + objTransaction.Id + '%';
        List<Integration_Logs__c> integrationLogs = [SELECT Id,Response_code__c,Integration_URL__c FROM Integration_Logs__c WHERE Identifier__c Like :indentifierForLogs];
        List<Transaction__c> transactionsAfterTest = [SELECT Transaction_Count__c,Number_of_Transaction_Items_in_SF__c FROM Transaction__c WHERE Id = :objTransaction.Id];
        System.assertNotEquals(transactionsAfterTest[0].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should NOT match with the count field on Transaction');
        System.assertEquals(0, integrationLogs.size(),'There should be NO integration logs created');
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Unit test scenario when transactionItem API is supposed to be called and fails
     * @param nonce
     */
    @IsTest
    public static void testTransactionItemAPIFail() {
        Test.setMock(HttpCalloutMock.class, new Katz_TransactionAPIsHttpMock('FAIL'));
        Transaction__c objTransaction = Katz_TestDataFactory.createTransactions(3, 1, true)[0];
        Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 2, true);

        //Data assert
        List<Transaction__c> transactions = [SELECT Id, (Select Id FROM TransactionItem__r) FROM Transaction__c];
        System.assertEquals(1, transactions.size(),'There should be only 1 transaction in the system at this moment');
        System.assertEquals(2, transactions[0].TransactionItem__r.size(),'There should be only 2 transaction items under this transaction');

        //Begin Test execution
        Test.startTest();
        TransactionItem__c transactionItem = Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 1, true)[0];
        Test.stopTest();

        //Functionality Assert
        String indentifierForLogs = '%' + objTransaction.Id + '%';
        List<Integration_Logs__c> integrationLogs = [SELECT Id,Response_code__c,Integration_URL__c FROM Integration_Logs__c WHERE Identifier__c Like :indentifierForLogs];
        List<Transaction__c> transactionsAfterTest = [SELECT Transaction_Count__c,Number_of_Transaction_Items_in_SF__c FROM Transaction__c WHERE Id = :objTransaction.Id];
        System.assertEquals(transactionsAfterTest[0].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on Transaction');
        System.assertEquals(1, integrationLogs.size(),'There should be 1 integration log created after the integration');
        System.assertNotEquals('200', integrationLogs[0].Response_code__c,'The response code for this unit test should be 200');
        System.assertEquals(true, integrationLogs[0].Integration_URL__c.contains('callout:DUMMY_API'),'The integration log should be created from the dummy API');
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Unit test scenario when transaction API is supposed to be called
     * @param nonce
     */
    @IsTest
    public static void testTransactionAPIPositive() {
        Test.setMock(HttpCalloutMock.class, new Katz_TransactionAPIsHttpMock('SUCCESS'));
        Transaction__c objTransaction = Katz_TestDataFactory.createTransactions(3, 1, true)[0];
        Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 3, true);
        String indentifierForLogs = '%' + objTransaction.Id + '%';
        System.debug('@@objTransaction 1' + objTransaction);
        //Data assert
        List<Transaction__c> transactions = [
                SELECT Id, Name, CreatedDate, Total_Cost__c, Number_of_Transaction_Items_in_SF__c, Total_Discount__c, Transaction_Count__c, (
                        SELECT Id, Name, Item_Cost__c
                        FROM TransactionItem__r
                )
                FROM Transaction__c
                WHERE Id = :objTransaction.Id
        ];
        System.assertEquals(1, transactions.size(),'There should be only 1 transaction in the system at this moment');
        System.assertEquals(3, transactions[0].TransactionItem__r.size(),'There should be only 3 transaction items under this transaction');
        System.assertEquals(transactions[0].Transaction_Count__c, transactions[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on Transaction');

        //Begin Test execution
        Test.startTest();
        System.enqueueJob(new Katz_QueueableTransactions(transactions[0])) ;
        Test.stopTest();

        //Functionality Assert
        List<Integration_Logs__c> integrationLogsAfter = [SELECT Id,Identifier__c,Response_code__c,Integration_URL__c FROM Integration_Logs__c WHERE Identifier__c Like :indentifierForLogs];
        System.assertEquals(2, integrationLogsAfter.size(),'There should be 2 integration log created after the integration call for both APIs');
        System.assertEquals('200', integrationLogsAfter[0].Response_code__c,'The response code for this unit test should be 200');
        System.assertEquals(true, integrationLogsAfter[0].Integration_URL__c.contains('callout:DUMMY_API'),'The integration log should be created from the dummy API');
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Unit test scenario when transaction API is to be called and fails
     * @param nonce
     */
    @IsTest
    public static void testTransactionAPIFail() {
        Test.setMock(HttpCalloutMock.class, new Katz_TransactionAPIsHttpMock('FAIL'));
        Transaction__c objTransaction = Katz_TestDataFactory.createTransactions(3, 1, true)[0];
        Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 3, true);
        String indentifierForLogs = '%' + objTransaction.Id + '%';
        //Data assert
        List<Transaction__c> transactions = [
                SELECT Id, Name, CreatedDate, Total_Cost__c, Number_of_Transaction_Items_in_SF__c, Total_Discount__c, Transaction_Count__c, (
                        SELECT Id, Name, Item_Cost__c
                        FROM TransactionItem__r
                )
                FROM Transaction__c
                WHERE Id = :objTransaction.Id
        ];
        System.assertEquals(1, transactions.size(),'There should be only 1 transaction in the system at this moment');
        System.assertEquals(3, transactions[0].TransactionItem__r.size(),'There should be only 3 transaction items under this transaction');
        System.assertEquals(transactions[0].Transaction_Count__c, transactions[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on Transaction');

        //Begin Test execution
        Test.startTest();
        System.enqueueJob(new Katz_QueueableTransactions(transactions[0])) ;
        Test.stopTest();

        //Functionality Assert
        List<Integration_Logs__c> integrationLogsAfter = [SELECT Id,Response_code__c,Integration_URL__c FROM Integration_Logs__c WHERE Identifier__c Like :indentifierForLogs];
        System.assertEquals(2, integrationLogsAfter.size(),'There should be 2 integration logs created after the integration call for both APIs');
        System.assertNotEquals('200', integrationLogsAfter[0].Response_code__c,'The response code for this unit test should NOT be 200');
        System.assertEquals(true, integrationLogsAfter[0].Integration_URL__c.contains('callout:DUMMY_API'),'The integration log should be created from the dummy API');
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Unit test scenario when bulk transactionItems for multiple transactions are inserted &
     *                transactionItem API is supposed to be called and is successful
     * @param nonce
     */
    @IsTest
    public static void testTransactionItemAPIBulk() {
        Test.setMock(HttpCalloutMock.class, new Katz_TransactionAPIsHttpMock('SUCCESS'));
        List<Transaction__c> transactions = Katz_TestDataFactory.createTransactions(3, 4, true);
        List<TransactionItem__c> transactionItems = new List<TransactionItem__c>();
        for (Transaction__c objTransaction : transactions) {
            transactionItems.addAll(Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 2, false));
        }
        insert transactionItems;

        //Data assert
        transactions = [SELECT Id, (Select Id FROM TransactionItem__r) FROM Transaction__c];
        System.assertEquals(4, transactions.size(),'There should be only 4 transactions in the system at this moment');
        System.assertEquals(2, transactions[0].TransactionItem__r.size(),'There should be only 2 transaction items under the first transaction record');
        System.assertEquals(2, transactions[1].TransactionItem__r.size(),'There should be only 2 transaction items under the first transaction record');
        System.assertEquals(2, transactions[2].TransactionItem__r.size(),'There should be only 2 transaction items under the first transaction record');
        System.assertEquals(2, transactions[3].TransactionItem__r.size(),'There should be only 2 transaction items under the first transaction record');

        //Begin Test execution
        Test.startTest();
        List<TransactionItem__c> newTransactionItems = new List<TransactionItem__c>();
        for (Transaction__c objTransaction : transactions) {
            newTransactionItems.addAll(Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 1, false));
        }
        insert newTransactionItems;
        Test.stopTest();

        //Functionality Assert
        List<Integration_Logs__c> integrationLogs = [
                SELECT Id,Response_code__c,Integration_URL__c,Identifier__c
                FROM Integration_Logs__c
        ];

        List<Transaction__c> transactionsAfterTest = [SELECT Transaction_Count__c,Number_of_Transaction_Items_in_SF__c FROM Transaction__c];
        System.assertEquals(4, transactionsAfterTest.size(),'There should be only 4 transactions in the system at this moment');
        System.assertEquals(transactionsAfterTest[0].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on the 1st Transaction');
        System.assertEquals(transactionsAfterTest[1].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on the 2nd Transaction');
        System.assertEquals(transactionsAfterTest[2].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on the 3rd Transaction');
        System.assertEquals(transactionsAfterTest[3].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on the 4rd Transaction');

        System.assertEquals(1, integrationLogs.size(),'There should be 1 integration log created after the integration');
        System.assertEquals('200', integrationLogs[0].Response_code__c,'The response code for this unit test should be 200');
        System.assertEquals(true, integrationLogs[0].Integration_URL__c.contains('callout:DUMMY_API'),'The integration log should be created from the dummy API');
        System.assertEquals(true, integrationLogs[0].Identifier__c != null);
        System.assertEquals(true, integrationLogs[0].Identifier__c.contains(transactions[0].Id),'The integration log should have 1st transactionid as one of the identifier');
        System.assertEquals(true, integrationLogs[0].Identifier__c.contains(transactions[1].Id),'The integration log should have 2nd transactionid as one of the identifier');
        System.assertEquals(true, integrationLogs[0].Identifier__c.contains(transactions[2].Id),'The integration log should have 3rd transactionid as one of the identifier');
        System.assertEquals(true, integrationLogs[0].Identifier__c.contains(transactions[3].Id),'The integration log should have 4th transactionid as one of the identifier');

    }

    /**
    * @author  : Mehul Jain
    * @date : 10/10/2020
    * @description : Unit test scenario when transactionItem API is supposed to be called and requires retrigger
    * @param nonce
    */
    @IsTest
    public static void testTransactionItemAPIRetrigger() {
        Test.setMock(HttpCalloutMock.class, new Katz_TransactionAPIsHttpMock('RETRIGGER'));
        Transaction__c objTransaction = Katz_TestDataFactory.createTransactions(3, 1, true)[0];
        Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 2, true);

        //Data assert
        List<Transaction__c> transactions = [SELECT Id, (Select Id FROM TransactionItem__r) FROM Transaction__c];
        System.assertEquals(1, transactions.size(),'There should be only 1 transaction in the system at this moment');
        System.assertEquals(2, transactions[0].TransactionItem__r.size(),'There should be only 2 transaction items under the first transaction');

        //Begin Test execution
        Test.startTest();
        TransactionItem__c transactionItem = Katz_TestDataFactory.createTransactionItems(objTransaction.Id, 1, true)[0];
        Test.stopTest();

        //Functionality Assert
        String indentifierForLogs = '%' + objTransaction.Id + '%';
        List<Integration_Logs__c> integrationLogs = [SELECT Id,Response_code__c,Integration_URL__c FROM Integration_Logs__c WHERE Identifier__c Like :indentifierForLogs];
        List<Transaction__c> transactionsAfterTest = [SELECT Transaction_Count__c,Number_of_Transaction_Items_in_SF__c FROM Transaction__c WHERE Id = :objTransaction.Id];
        System.assertEquals(transactionsAfterTest[0].Transaction_Count__c, transactionsAfterTest[0].Number_of_Transaction_Items_in_SF__c,'The number of actual transaction items should match with the count field on Transaction');
        System.assertEquals(1, integrationLogs.size(),'There should be 1 integration log created after the integration');
        System.assertEquals('500', integrationLogs[0].Response_code__c,'The response code for this unit test should be 500');
        System.assertEquals(true, integrationLogs[0].Integration_URL__c.contains('callout:DUMMY_API'),'The integration log should be created from the dummy API');
    }

}
