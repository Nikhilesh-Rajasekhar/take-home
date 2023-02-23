# Deploying Two Independent Containers on AWS EKS with Horizontal Pod Autoscaling
This project demonstrates how to deploy two independent containers on AWS Elastic Kubernetes Service (EKS) with horizontal pod autoscaling.

**Prerequisites**

Before you begin, you need the following:

- An AWS account with permissions to create EC2 instances, load balancers, and other resources.
- A working knowledge of Kubernetes and Terraform.
- The kubectl and terraform command-line tools installed on your local machine.
- Before you begin, make sure you have the following installed:
  - Terraform
  - kubectl
  - aws-iam-authenticator

**Step 1: Create an IAM user and access keys**

To deploy resources on AWS using Terraform, you need an IAM user with the appropriate permissions. Follow these steps to create an IAM user and access keys:

1. Log in to your AWS console.
2. Click on Services and select IAM from the list of services.
3. Click on Users in the left-hand menu, and then click on the Add user button.
4. Enter a name for the user, and select Programmatic access as the access type.
5. Click on Next: Permissions to proceed to the permissions screen.
6. Select the Attach existing policies directly option, and then select the AmazonEC2FullAccess and AmazonEKSClusterPolicy policies.
7. Click on Next: Tags to proceed to the tags screen (optional), and then click on Next: Review.
8. Review your settings, and then click on Create user to create the user.
9. After the user is created, click on Download .csv to download the access keys for the user.

**Step 2: Set up Terraform**

Now that you have an IAM user with the appropriate permissions, you can set up Terraform on your local machine. Follow these steps to set up Terraform:

1. Create a new directory for your Terraform project.
2. Create a new file named main.tf in your project directory, and copy the contents of the main.tf file provided in this repository.
3. Create a new file named variable.tf in your project directory, and copy the contents of the variable.tf file provided in this repository.
4. Create a new file named terraform.tfvars in your project directory, and copy the contents of the terraform.tfvars file provided in this repository. Update the values as needed for your environment.

**Step 3: Deploy Kubernetes resources**

Now that Terraform is set up, you can use it to deploy Kubernetes resources on AWS. Follow these steps to deploy the resources:

1. Open a terminal or command prompt, and navigate to your Terraform project directory.
2. Run terraform init to initialize the project.
3. Run terraform plan to preview the resources that will be created.
4. Run terraform apply to create the resources.
5. After the resources are created, run kubectl get pods to verify that the pods are running.
6. Run kubectl get services to get the URL of the load balancer.
7. Open a web browser and navigate to the load balancer URL to verify that the APIs are working.

**Step 4: Horizontal Pod Autoscaler (HPA): Automatically Scale the Deployments**

1. Install the Kubernetes Metrics Server.
2. Verify that the Metrics Server is up and running by checking the deployment status.
3. Add the resource requests and limits for CPU in the deployment yaml file for each of the two containers.
4. Create an HPA resource for each deployment by running the following command:

| kubectl autoscale deployment \<deployment-name\> --cpu-percent=70 --min=1 --max=10 |
| --- |

Replace \<deployment-name\> with the name of each deployment. This command creates an HPA that targets the CPU utilization of the containers in the specified deployment, with a minimum of 1 replica and a maximum of 10 replicas.

5. Verify that the HPA is created by running the following command:

| kubectl get hpa |
| --- |

Test the autoscaling by generating load on the deployments using a tool like Apache JMeter or hey. You should see the number of replicas increase as the CPU utilization reaches 70%.

**Step 5: Ensure Rolling Deployments and Rollbacks**

1. Open the deployment YAML file for each container, which should be named "deployment-users.yaml" and "deployment-shifts.yaml". Edit it to ensure that only one new pod is created at a time during a rolling update, and that no more than one pod is unavailable at any given time.
2. Add a readiness probe for each container to ensure that new pods are ready before old ones are terminated during a rolling update. Edit it to ensure that the container is considered "ready" only after the "/health" endpoint returns a successful response.
3. Apply the changes using the following commands:


| kubectl apply -f deployment-users.yamlkubectl apply -f deployment-shifts.yaml |
| --- |

4. Verify that the changes were applied correctly by running the following command:

| kubectl get deployment |
| --- |

This should show the updated deployments with the new configuration settings and readiness probes.

5. To test rolling updates, make a change to the Docker image or code for one of the containers, then run the following command:

| kubectl set image deployment/\<DEPLOYMENT\_NAME\> \<CONTAINER\_NAME\>=\<NEW\_IMAGE\_NAME\> |
| --- |

Replace \<DEPLOYMENT\_NAME\> and \<CONTAINER\_NAME\> with the appropriate values for the container you want to update, and \<NEW\_IMAGE\_NAME\> with the name of the new Docker image you want to use. This will trigger a rolling update for that container, allowing you to test the new configuration settings and readiness probes.

6. To rollback a deployment, run the following command:

| kubectl rollout undo deployment/\<DEPLOYMENT\_NAME\> |
| --- |

**Step 6: Implement Role-Based Access Control (RBAC)**

In this step, we will create a Kubernetes role and role binding to restrict access to certain commands for our development team.

1. Create a file called role.yaml. This file creates a Role object that grants read-only access to pods and their logs.

2. Apply the role to the cluster using the following command:

| kubectl apply -f role.yaml |
| --- |

3. Create a file called role-binding.yaml. Replace \<YOUR\_DEV\_TEAM\_USERNAME\> with the username of your development team member. This file creates a RoleBinding object that binds the limited-access Role to your development team member's user account.

4. Apply the role binding to the cluster using the following command. This will ensure that your development team member has restricted access to the Kubernetes resources.

| kubectl apply -f role-binding.yaml |
| --- |

**Bonus:**

- **Apply Configurations to Multiple Environments**

In this step, we will create separate Kubernetes configuration files for staging and production environments.

1. Create a new directory called staging and production in the root directory of your project.
2. Copy the deployment.yaml, service.yaml, hpa.yaml, role.yaml, and role-binding.yaml files into each of the respective environment directories.
3. Update the values in the terraform.tfvars file to specify the environment you want to deploy to:

| environment = "staging" |
| --- |

Or

| environment = "production" |
| --- |

4. Run terraform apply to deploy the resources to the selected environment.

- **Auto-scale Based on Network Latency**

In this step, we will modify the Horizontal Pod Autoscaler to scale based on network latency instead of CPU utilization.

1. Open the kubernetes files. Modify the resource section to look like the following:

| resource:name: network-traffictarget:type: UtilizationaverageValue: 500m |
| --- |

This sets the HPA to scale based on network traffic utilization, with a target average value of 500 milliunits.

2. Apply the changes to the cluster using the following command:

| kubectl apply -f hpa.yaml |
| --- |

Now, your Kubernetes cluster will scale the pods based on network traffic utilization.
