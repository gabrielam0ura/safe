import type { FastifyInstance } from "fastify";
import { create } from "./controllers/notes/create";

export async function appRoutes(app: FastifyInstance) {
    app.post("/notes", create)
}