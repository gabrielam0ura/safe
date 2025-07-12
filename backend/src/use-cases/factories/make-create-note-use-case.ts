import { PrismaNotesRepository } from "@/repositories/prisma/prisma-notes-repository"
import { CreateNoteUseCase } from "../create-note"

export function makeCreateNoteUseCase() {
  const notesRepository = new PrismaNotesRepository()
  const useCase = new CreateNoteUseCase(notesRepository)

  return useCase
}