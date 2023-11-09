up:
	docker-compose up -d

down:
	docker-compose down

nvim:
	docker exec -it neovim /bin/bash

cp:
	docker cp neovim:/root/.config/nvim ./dotfiles/config/
