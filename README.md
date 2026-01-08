# AWS VPC: Public App & Private DB with Security Group Referencing

## Overview
This project demonstrates a cost-optimized AWS VPC design where:
- Application EC2 is deployed in a public subnet
- Database EC2 is deployed in a private subnet
- Access to the database is restricted using security group referencing
- No NAT Gateway is used to avoid unnecessary cost

## Architecture
- VPC with public and private subnets
- Internet Gateway attached to VPC
- App EC2 (public subnet)
- DB EC2 (private subnet)
- Security Groups:
  - sg-app: allows SSH from my IP
  - sg-db: allows SSH and DB traffic only from sg-app

## Security Design
- Database instance has no public IP
- No inbound access from the internet to the database
- SSH access to DB is only possible via the App EC2 (acting as a jump host)

## Testing
| Test Case | Result |
|---------|--------|
| SSH from local machine to DB | ❌ Blocked |
| SSH from App EC2 to DB | ✅ Allowed |

## Cost Consideration
- EC2 instances use Free Tier eligible instance types
- No NAT Gateway or Elastic IP was used
- Resources were terminated after testing

## Key Learnings
- Difference between public and private subnets
- Security group referencing
- Bastion / jump host access pattern
- Cost-aware architecture design


