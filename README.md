# Hindsight-SDGP-CS18
This application is a mental health support application that uses LLMs to analyze the emotional state of a user based on their journal entries to the application

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
