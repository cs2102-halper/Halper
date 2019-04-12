********************************************************************
               H A L P E R    A P P L I C A T I O N
********************************************************************
Author: Team Halper
Group Number: 01
********************************************************************
 
DESCRIPTION:
Halper is a web-based application that functions as a task matching 
platform where users are either looking for helpers to complete 
some temporary tasks or bidding as helpers to complete some 
freelance tasks. As users who are hiring helpers, they are allowed 
to create a task based on different categories and disclose the 
highest amount of price they can pay to each helper. Whereas for 
users who are looking for a task through the application, they will 
be able to show interest in a particular task by bidding a price as 
the amount that they will be paid after they have completed the 
task. As such, the lowest bidder will only be assigned to the task 
unless the task creator assigns the specific user for the task. 
Each task is tagged with an open time where it will stay open for 
any bidders to bid for the task. Once the task bidding timer has 
ended, the application will automatically select the lowest price 
bidder and assign them to the task. The task will now become an 
In-progress task where the assigned bidder should proceed to do 
his assigned task. When the job is complete, the task creator will 
mark his task as completed and the task will then become a 
Completed Task.

Other than the task matching functionalities, Halper has a review 
system where both the creator of the task and the helper are able 
to give each other their feedback. They are also allowed to give 
a rating from 0 to 5. These ratings will be accumulated into each 
account as points and users will be able to attain levels based 
on their points. Currently, each level requires 10 points starting 
from level 0. The number of points tagged to each account will 
allow users to build their reputations as helpers so that they will 
have a higher chance to successfully bid for a task in the long run. 
Furthermore, this will be beneficial towards task creators as they 
will be able to know more about the credibility of each helper based 
on their ratings. 

Users in Halper are allowed to create tasks and bids for tasks 
concurrently. The application is developed to ensure every user 
have the rights to request for help and given the chance to earn 
some money for doing a task.

********************************************************************
INSTALLATION:

0. Prerequisites:
	-	Node.js
	-	Postgresql

1. 	Download the .zip folder from 
	https://github.com/cs2102-halper/Halper

2. 	Unzip the content of the files into your C:\ directory (preferred)

3. 	Open CMD or Powershell and go into Halper directory.

4.	Execute the following command: npm install dependencies
	This will install all dependencies required by Halper front-end
	
5.	Run the server using this command: npm run dev

6.	Backend (postgresql)
	Two files has been provided to help you setup your database.
	1. \Halper\Database\halper_db_setup.sql
	2. \Halper\Database\testdata.sql
	#1 Helps you configure your database to support Halper front-end
	#2 Helps you populate data for testing purposes.
	
7.	Recommended browser to use: Google Chrome
	Goto: localhost:3000
	
	You may now explore Halper!
********************************************************************
