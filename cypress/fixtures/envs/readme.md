
### Requirements to the environment

* environment should contain the following users:
    * defaultUser(admin user; should be able to see all chatbots)
    * viewOtherOfficesChatbot(View other offices + Chatbot Standard)
    * viewOtherOfficesLiveChat(View other offices + Live Chat Standard)
    * viewOtherOfficesCampaigns(View other offices + Campaigns Standard)
    * chatbotLimited
    * chatbotStandard
    * chatbotAdmin
    * liveChatLimited
    * liveChatStandard
    * liveChatAdmin
    * campaignsLimited
    * campaignsStandard
    * campaignsAdmin
    * chatbotStandard-FinancialAidOffice
    * chatbotStandard-BookstoreOffice
    use password 'Passwordforautomation1!' for all users and use the following email template "user_name@automation.com"
* custom questions list should contain 2+ items ('Custom question for automation')
* awaiting review list should contain 1+ items ('Question for 'Awaiting Review' test')
* contact lists should contain 1+ items(create contact list with name - ContactListForTests)
* chatbot should have 1+ transcripts
* Live Chat transcripts should contain 2+ record(the first message - 'Hi Office 1'
* and 'Hi Office 2' for the 2nd office)

### Chatbot configuration
* enable feedback for the chatbot
* enable campaigns/nudge
* Chatbot has 1 campus. Add these libraries: Financial Aid, Bookstore, Admissions. 
* Campus has 3 offices: Financial Aid(add financial aid library to this office), Bookstore(add bookstore library to it)
* and Athletics(add financial aid library)
