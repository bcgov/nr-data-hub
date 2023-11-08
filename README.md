# nr-event-based-data
Repository housing POC code for event based data services hosted on AWS.

## TODO / Onboarding / Notes

- AWS CLI installation
- Terraform installation
- Extend configuration files to include new user
- Terraform init doesn't work on the VPN
- Enforce updating terraform versions using dependabot
- AWS X-Ray for better tracing
- AWS Lake Formation to centralise data lake governance? Investigate
- Tag everything for cost reporting
- Add SQS queue between rule and Lambda so we can process in batches