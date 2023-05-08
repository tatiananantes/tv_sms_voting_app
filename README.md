# :tv: TV SMS Voting App
### This app displays the results for TV SMS voting campaigns, derived from a log data file import. 


#### :page_facing_up: Requirements for the application:  
- DB to store the imported data from the file

- Basic FE views which: 
  - present a list of campaigns for which we have results 
  - when a campaign is selected a list of candidates, their scores, and the number of messages that were sent in but not counted is displayed

- A command line script that will import log file data into the application. Any lines that are not well-formed should be discarded.

- Parsing Rules:
  - A well formed log line will have the same fields, in the same order. They will all begin with VOTE, then have an epoch time value, then a set of fields with an identifier, a colon, and the value of the field like so:
  ```
  VOTE 1168041980 Campaign:ssss_uk_01B Validity:during Choice:Tupele CONN:MIG00VU MSISDN:00777778429999 GUID:A12F2CF1-FDD4-46D4-A582-AD58BAA05E19 Shortcode:63334
  ```
  - A campaign is an episode of voting
  - 'Choice:' indicates the candidate the user is voting for. In every campaign there will be a limited set of candidates that can be voted for. If Choice is blank, it means the system could not identify the chosen candidate from the text of the SMS message. All such messages should be counted together as 'errors', irrespective of their Validity values. There is a limited set of values for 'Choice', each of which represents a candidate who can be voted for.
  - Validity classifies the time when the vote arrived, relative to the time window when votes will count towards a candidate's score.  Only votes with a Validity of 'during' should count towards a candidate's score. Other possible values of Validity are 'pre' (message was too early to be counted), 'post' (message was too late to be counted). 'pre' and 'post' messages should be counted together irrespective of the candidate chosen.
  - The CONN, MSISDN, Shortcode and GUID fields are not relevant for this app at this moment in time
  

#### :thought_balloon: Approach: 
- DB & Data Model: Used PostgresSQL DB which can handle complex queries and large volumes of data. Tables were created for: 
  - Candidates (stores candidate information) > belongs to campaign has many votes
  - Campaigns(stores campaign name) > belongs to campaign and has many votes
  - Votes (stores epoch, references campaign_id & candidate_id, validity) > Vote belongs to Campaign and Candidate
- Import: making the import script as a module makes it a reusable and modular component that can be easily incorporated into different parts of the application, allowing also to be easily extended if needed.
- Design/UI: Used TailWind to quickly add some basic design to the application 
- Testing: 100 % test coverage using RSPEC

#### Screenshots

Campaigns index page

<img width="1212" alt="Screenshot 2023-05-08 at 00 42 25" src="https://user-images.githubusercontent.com/10349072/236811590-c0f616be-1534-44a8-80f8-92966c57daa5.png">

Campaign show page

<img width="907" alt="Screenshot 2023-05-08 at 00 42 34" src="https://user-images.githubusercontent.com/10349072/236811618-ec653da5-616c-437d-9303-90b384a1a517.png">

Test Coverage

![Screenshot 2023-05-07 at 20 14 29](https://user-images.githubusercontent.com/10349072/236857519-9b8e2c5a-8e52-4b22-a934-b36a09bea87d.png)

No failing tests

![image](https://user-images.githubusercontent.com/10349072/236858741-a35d70ab-9d47-44ee-b44e-1ceb24f6626e.png)

Data Upload in DB

![Screenshot 2023-05-07 at 20 14 14](https://user-images.githubusercontent.com/10349072/236857651-800bb646-2deb-4c18-b8d0-7d48886f65fc.png)

### How to run
- Clone the repo to your local `https://github.com/tatiananantes/tv_sms_voting_app.git`
- Go into the project directory: `cd tv_sms_voting_app`
- Run `bundle install` to install required dependencies
- Set up DB by running: `rails db:create db:migrate`
- Run the import script in a terminal window `rails runner app/scripts/import_log_file_runner.rb` to run the sample votes.txt file or `rails runner app/scripts/import_log_file_runner.rb <path/to/anotherfile>`. You will see the message 'Processing' and then 'Done' once the upload has been completed. You can check the DB has been populated with this data 
- Go `http://localhost:3000/campaigns/` to view the app

