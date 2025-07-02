bootstrap-dev:
	@echo "- Bootstrap dev Environment..."
	chmod +x ./bootstrap/setup
	./bootstrap/setup bootstrap dev dynatrace eng eu-west-2 aws-infra-deploy-dynatrace dynatrace
	@echo "✔ Done"

bootstrap-stg:
	@echo "- Bootstrap dev Environment..."
	chmod +x ./bootstrap/setup
	./bootstrap/setup bootstrap stg dynatrace eng eu-west-2 aws-infra-deploy-dynatrace dynatrace
	@echo "✔ Done"

bootstrap-prd:
	@echo "- Bootstrap dev Environment..."
	chmod +x ./bootstrap/setup
	./bootstrap/setup bootstrap prd dynatrace eng eu-west-2 aws-infra-deploy-dynatrace dynatrace
	@echo "✔ Done"

bootstrap-epma-berk-dev:
	@echo "- Bootstrap dev EPMA Berks Environment..."
	chmod +x ./bootstrap/setup
	./bootstrap/setup bootstrap dev dynatrace england eu-west-2 aws-infra-deploy-dynatrace dynatrace
	@echo "✔ Done"

