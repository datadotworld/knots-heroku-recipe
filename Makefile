setup-py-envs:
	$(MAKE) -C knot setup-py-envs

sync:
	$(MAKE) -C knot py-sync
