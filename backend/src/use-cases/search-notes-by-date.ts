import type { NotesRepository } from '@/repositories/notes-repository'
import type { Note } from '@prisma/client'

interface SearchNotesByDateUseCaseRequest {
  startDate: Date
  endDate: Date
  userId: string
}

interface SearchNotesByDateUseCaseResponse {
  notes: Note[]
}

export class SearchNotesByDateUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    startDate,
    endDate,
    userId
  }: SearchNotesByDateUseCaseRequest): Promise<SearchNotesByDateUseCaseResponse> {
    const notes = await this.notesRepository.searchManyByDate(startDate, endDate, userId)

    return {
      notes,
    }
  }
}