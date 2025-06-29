import type { FastifyInstance } from "fastify";
import { create } from "./controllers/notes/create";
import { list } from "./controllers/notes/fetch";

export async function appRoutes(app: FastifyInstance) {
    app.get("/notes", list)
    
    app.post("/notes", create)
}