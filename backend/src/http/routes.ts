import type { FastifyInstance } from "fastify";
import { create } from "./controllers/notes/create";
import { list } from "./controllers/notes/fetch";
import { update } from "./controllers/notes/update";
import { deleteNote } from "./controllers/notes/delete";

export async function appRoutes(app: FastifyInstance) {
    app.get("/notes", list)

    app.post("/notes", create)

    app.put("/notes/:noteId", update)
    app.delete("/notes/:noteId", deleteNote)
}