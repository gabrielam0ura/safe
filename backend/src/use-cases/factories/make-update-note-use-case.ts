import { PrismaNotesRepository } from "@/repositories/prisma/prisma-notes-repository"
import { UpdateNoteUseCase } from "../update-note"

export function makeUpdateNoteUseCase() {
  const notesRepository = new PrismaNotesRepository()
  const useCase = new UpdateNoteUseCase(notesRepository)

  return useCase
}