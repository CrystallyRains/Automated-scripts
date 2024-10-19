Jenkins Installation and Configuration Documentation

#######################################################################################################
Task 1: Install Jenkins using Docker

Install Docker on your local machine if you haven't already.
If you're not running as the root user, add your username to the Docker group using the command: sudo usermod -aG docker your-username
Pull the Jenkins image from Docker Hub using the command: docker pull jenkins/jenkins:lts (use sudo docker pull if necessary)
Run the Jenkins container using the command: docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts (use sudo docker run if necessary)
Access Jenkins using a web browser at http://localhost:8080


#######################################################################################################
Task 2: Create a Sample Freestyle Job

Log in to Jenkins using the default credentials (username: admin, password: admin)
Click on "New Item" and select "Freestyle project"
Give your job a name, e.g., "Hello DevOps"
Click "OK"
Add a build step: "Execute shell" with the command echo "Hello DevOps"
Click "Save"


#######################################################################################################
Task 3: Create a Jenkinsfile for the Sample Job

The Jenkinsfile is already provided in the same folder.
To create a new pipeline job in Jenkins, click on "New Item" and select "Pipeline".
Enter a name for your pipeline job, e.g., "Hello DevOps Pipeline".
Select "Pipeline script from SCM" as the pipeline definition.
Select "Git" as the SCM (Source Control Management) system.
Enter the GitHub repository URL, e.g., https://github.com/your-username/your-repo-name.git.
Enter the branch name, e.g., "main".
Click "Save".

#######################################################################################################
Task 4: Configure Jenkins to Use the GitHub Repository

Create a new GitHub repository for your project
Create a new branch in the repository, e.g., "main"
Add the Jenkinsfile to the repository
Log in to Jenkins and click on "New Item"
Select "Pipeline" as the job type
Enter a name for your pipeline job, e.g., "Hello DevOps Pipeline"
Select "Pipeline script from SCM" as the pipeline definition
Select "Git" as the SCM (Source Control Management) system
Enter the GitHub repository URL, e.g., https://github.com/your-username/your-repo-name.git
Enter the branch name, e.g., "main"
Click "Save"
Note: Replace your-username and your-repo-name with your actual GitHub username and repository name.





