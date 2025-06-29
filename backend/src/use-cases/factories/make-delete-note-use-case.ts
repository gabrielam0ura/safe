import { PrismaNotesRepository } from "@/repositories/prisma/prisma-notes-repository"
import { DeleteNoteUseCase } from "../delete-note"

export function makeDeleteNoteUseCase() {
  const notesRepository = new PrismaNotesRepository()
  const useCase = new DeleteNoteUseCase(notesRepository)

  return useCase
}