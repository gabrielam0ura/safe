import { PrismaNotesRepository } from "@/repositories/prisma/prisma-notes-repository"
import { SearchNotesByDateUseCase } from "../search-notes-by-date"

export function makeSearchNotesByDateUseCase() {
  const notesRepository = new PrismaNotesRepository()
  const useCase = new SearchNotesByDateUseCase(notesRepository)

  return useCase
}