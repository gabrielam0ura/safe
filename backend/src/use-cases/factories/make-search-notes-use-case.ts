import { PrismaNotesRepository } from "@/repositories/prisma/prisma-notes-repository"
import { SearchNotesUseCase } from "../search-notes"

export function makeSearchNotesUseCase() {
  const notesRepository = new PrismaNotesRepository()
  const useCase = new SearchNotesUseCase(notesRepository)

  return useCase
}