import { PrismaNotesRepository } from "@/repositories/prisma/prisma-notes-repository"
import { FetchNotesUseCase } from "../fetch-notes"

export function makeFetchNotesUseCase() {
  const notesRepository = new PrismaNotesRepository()
  const useCase = new FetchNotesUseCase(notesRepository)

  return useCase
}