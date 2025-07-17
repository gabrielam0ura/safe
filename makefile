deploy:
	docker compose down -v && docker compose up --build -d

mount-app:
	cd backend && pnpm i
	make deploy

prisma-studio:
	docker exec -it safe-backend pnpm prisma studio