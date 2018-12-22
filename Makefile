REPO_CMD=svn checkout --depth=files
REPO_URL_COMMUNITY=svn+ssh://svn-community@repos.archlinux.org/srv/repos

RED?=$(shell tput setaf 1)
GREEN?=$(shell tput setaf 2)
YELLOW?=$(shell tput setaf 3)
BLUE?=$(shell tput setaf 4)
BOLD?=$(shell tput bold)
RST?=$(shell tput sgr0)

git-hook:
	@for hook in .config/git/*.hook; do \
		echo "==> Linking hook: $${hook}"; \
		ln -sf "../../$${hook}" ".git/hooks/$$(basename $${hook%.hook})"; \
	done

update-index-file:
	@echo "$(BOLD)$(GREEN)[*] $(RST)$(BOLD)updating community.list index file...$(RST)"
	ls .repo/community|sort > .repo/community.list

repo-checkout:
	@echo "$(BOLD)$(GREEN)[*] $(RST)$(BOLD)Initialize community repo...$(RST)"
	${REPO_CMD} ${REPO_URL_COMMUNITY}/svn-community/svn .repo/community

repo-seed:
	@echo "$(BOLD)$(GREEN)[*] $(RST)$(BOLD)Seed community package list...$(RST)"
	@cd .repo; \
		curl -s "https://www.archlinux.org/packages/search/json/?sort=&q=&maintainer=Foxboron&flagged=" | jq -r '.results[].pkgbase' > community.list

add-packages: repo-seed
	@cd .repo/community; \
		for PKG in `cat ../community.list`; do \
			[ ! -d ../../$${PKG} ] && echo "$(BOLD)$(GREEN)[*] $(RST)$(BOLD)Checkout community/$${PKG}...$(RST)"; \
			[ ! -d ../../$${PKG} ] && svn update $${PKG} >/dev/null || true; \
		done
	@echo "$(BOLD)$(GREEN)[*] $(RST)$(BOLD)Adding new packages community...$(RST)"
	@.repo/init community

update: add-packages
	@echo "$(BOLD)$(GREEN)[*] $(RST)$(BOLD)Update community...$(RST)"
	@.repo/update community

update-version:
	@.repo/get-current-versions.sh > .repo/old.txt

check: update-version
	@nvchecker .repo/packages.ini
