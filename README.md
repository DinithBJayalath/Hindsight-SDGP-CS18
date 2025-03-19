# Hindsight 🧠
**Hindsight** is a mental health support application that allows users to Write journals that can be analyzed using an LLM to help users better understand themselves and improve their mental health.
## Key features
### Smart Journal 📖
Users can Write their thoughts in a journal that is connected to a RAG powered LLM to detect emotions of the journal content.  
This information will then be securely saved in a database for 90 days so users can see their mood changes and emotional states over time to better understand them.  

### Quick mood record 😄
If users are busy and don't have time to write in the journal, but they still want to track their emotions, they can uses the quick mood record feature to quickly record their mood using simple sliders and selections.

### Activity recommendation 🏃
Users can browse through activities to improve their mood or spend quality time.  
The application can also recommend users activities based on the emotional analysis of the journal content or the quick mood record.
These activities consist of exercieses, meditation activities, and creative activities like drawing.

### Historical analysis and report dashboard 📊
Users can get historical records of their emotional analysis and other information to help them understand patterns or trends in their mood helping them improve their mental health.

# Dev branch
The dev branch is the starting point of all feature development branches.  
Always make a feature branch and work, never work directly on the dev branch.  
Prefix your feature branches with "feature/".  
Please ask a 2nd person to confirm your merges or at least double-check your work.  
When merging make sure you're merging with the dev branch.  

# Folder structure
## algorithms
Code related to all algorithms (coded in Python) should be in this directory.  
Make a new sub-directory for your work.  

algorithms_service.py contains the main code for the gRPC service. Define a new Class for your service.  

## backend-core
This is a NestJS project that contains the code for the REST APIs in the backend and their related services.  
In the src folder create a new package for your feature and put the controller, service and the model related to that feature in that package.  

## frontend
This directory is the flutter project for the frontend of the application.  

## landing_page
This folder contains all the code and resources that is related to the landing page of the application  
This is a React project. The landing page is currently hosted with Vercel and this folder is the root and the entry point to that.

## proto
This directory contains the proto files for the gRPC services.  
make a new sub-directory for your feature and make the proto files related to that service in that sub-directory.  

## resources
This directory contains the SSL certificates used in the node server and the python server
