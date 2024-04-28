# AIP-MLops
This repository is for showcasing GitHub familiarity, using ArgoCD and Kubernetes for setting up a GitOps pipeline.

Aim
The aim of this assignment is to understand the hands-on experience with GitOps practices, utilizing Argo CD for continuous deployment and Argo Rollouts for advanced deployment strategies within a Kubernetes environment. 
Here I am using WSL with Ubuntu 22.04 as my environment.

Steps

Task 1: Setup and Configuration

Step 1: Create a GitRepository
Go to GitHub and create a new repository to host your source code.
You can either initialize the repository with a README file or create it empty.
This repository will serve as the single source of truth for your application's code, Kubernetes manifests, and other configuration files.

Step 2: Install Docker, kubeadm and kubectl
All of these pre-requisites are needed to run ArgoCD.
Install Docker, kubeadm and kubectl
Run minikube

Step 3: Install Argo CD on Your Kubernetes Cluster
Argo CD is a declarative continuous deployment tool for Kubernetes.
Follow the official Argo CD installation guide to install it on your Kubernetes cluster.
The installation process involves creating a namespace, installing the Argo CD components (controller, server, repo-server, etc.), and exposing the Argo CD API server.
After installation, you'll have access to the Argo CD UI and CLI for managing your GitOps workflow.

Step 4: Install Argo Rollouts
Argo Rollouts is a Kubernetes controller and set of CRDs that provide advanced deployment capabilities such as blue-green and canary deployments.
Follow the official Argo Rollouts installation guide to install it on your Kubernetes cluster.
This typically involves creating a namespace and installing the Argo Rollouts controller and CRDs.



Task 2: Creating the GitOps Pipeline

Step 1: Dockerize the Application
Choose a simple web application you want to deploy. You can use a pre-existing application or create a new one.
Create a Dockerfile in your repository to define the application's Docker image.
Build the Docker image locally using the docker build command.
Push the Docker image to a public container registry of your choice (e.g., Docker Hub, Google Container Registry, or Amazon Elastic Container Registry).
Dockerizing the website
The website directory contains 4 files: index.html, sample_page.html, sample_image.jpg, style.css

Step 2: Deploy the Application Using Argo CD
In your repository, create Kubernetes manifests (e.g., Deployment, Service) for your web application, using the Docker image you pushed in the previous step.
Configure Argo CD to monitor your repository by creating an Application resource in Argo CD. This resource specifies the repository URL, target Kubernetes namespace, and path to your manifests.
Argo CD will automatically deploy your application to the specified namespace based on the manifests in your repository.
Verify that your application is running in the Kubernetes cluster.

‘admin’ is the username. To get the one time password for logging in, run:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo



Task 3: Implementing a Canary Release with Argo Rollouts

Canary Releases
A canary release is a deployment strategy where a new version of an application is gradually rolled out to a small subset of users or traffic before being fully deployed to the entire user base. This approach allows you to test the new version in a production environment while minimizing the risk of introducing bugs or issues that could impact all users.
The term "canary" refers to the historical practice of using canaries in coal mines to detect toxic gases. If the canary became ill or died, it would signal danger and alert the miners to evacuate. Similarly, in a canary release, the initial subset of users acts as the "canary," allowing you to detect and address any issues before rolling out the new version more broadly.

Argo Rollouts
Argo Rollouts is a Kubernetes controller and set of custom resource definitions (CRDs) that provide advanced deployment capabilities, including canary releases, blue-green deployments, and other progressive delivery strategies.
With Argo Rollouts, you can define the desired deployment strategy for your application in a declarative manner, and the controller will orchestrate the deployment process according to your specifications. This allows you to automate and control the rollout process, including steps like traffic routing, scaling, and analysis of metrics and logs.

Deployment Strategies
Argo Rollouts supports several deployment strategies, including:
Canary: A new version is gradually rolled out to a specified percentage of traffic, allowing you to test it in production before fully deploying it.
Blue-Green: Two separate environments (blue and green) are maintained, and traffic is shifted between them during a deployment.
Rolling Update: The new version is gradually rolled out to replace the old version, with a configurable percentage of instances being updated at a time.
A/B Testing: Two versions of the application are deployed simultaneously, and traffic is split between them based on defined criteria, allowing you to test different versions with real users.


Step 1: Define a Rollout Strategy
Modify your application's Deployment manifest to use the Argo Rollouts Rollout resource instead of a standard Deployment.
In the Rollout definition, specify a canary release strategy by setting the strategy.canary field. This defines the percentage of traffic that should be routed to the new version during the canary phase.

Step 2: Trigger a Rollout
Make a change to your web application's code and rebuild the Docker image with a new tag.
Push the new Docker image to your container registry.
Update the Rollout manifest in your repository to use the new Docker image tag.
Argo CD will detect the changes in your repository and trigger a new rollout, following the canary release strategy you defined.

Step 3: Monitor the Rollout
Use the Argo Rollouts UI or CLI to monitor the progress of the canary release.
Argo Rollouts will gradually shift traffic to the new version, allowing you to validate its behavior before fully promoting it.
If the canary release is successful, you can promote the new version to serve 100% of the traffic. If issues arise, you can abort the rollout and roll back to the previous stable version.
If the new version performs well, you can resume the Rollout by clicking the "RESUME" button in the Argo CD UI or using the Argo Rollouts CLI: kubectl argo rollouts promote my-website
If issues are detected with the new version, you can abort the Rollout and roll back to the previous stable version using the Argo CD UI or the Argo Rollouts CLI: kubectl argo rollouts abort my-website



Task 4: Documentation and Cleanup

Step 1: Document the Process
Create a README.md file in your repository, detailing the steps you followed for this assignment.
Include any challenges you encountered and how you resolved them.
Explain the GitOps principles you followed and how Argo CD and Argo Rollouts facilitated the deployment and release process.

Step 2: Clean Up
In the README.md file, document the steps to cleanly remove all resources created during this assignment from your Kubernetes cluster. 
Delete the my-website application from Argo CD: argocd app delete my-website
This may include deleting the Argo CD and Argo Rollouts installations, removing the deployed application resources, and any other related resources you created: 
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete -n your-namespace -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/manifests/install.yaml
Stop Minikube instances by:
minikube stop 
minikube delete
