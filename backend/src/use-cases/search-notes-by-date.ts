import type { NotesRepository } from '@/repositories/notes-repository'
import type { Note } from '@prisma/client'

interface SearchNotesByDateUseCaseRequest {
  date: Date
}

interface SearchNotesByDateUseCaseResponse {
  notes: Note[]
}

export class SearchNotesByDateUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    date,
  }: SearchNotesByDateUseCaseRequest): Promise<SearchNotesByDateUseCaseResponse> {
    const notes = await this.notesRepository.searchManyByDate(date)

    return {
      notes,
    }
  }
}