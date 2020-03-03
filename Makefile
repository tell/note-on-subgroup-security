.DEFAULT_GOAL := demo
SAGE = sage
.PHONY: demo
demo:
	$(SAGE) attack.sage
	$(SAGE) circuit_privacy.sage
.PHONY: check
check:
	$(SAGE) check_scheme.sage
	$(SAGE) check_scheme_light.sage
