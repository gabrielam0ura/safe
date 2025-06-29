import type { NotesRepository } from '@/repositories/notes-repository'
import type { Note } from '@prisma/client'

interface SearchNotesUseCaseRequest {
  query: string
}

interface SearchNotesUseCaseResponse {
  notes: Note[]
}

export class SearchNotesUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    query,
  }: SearchNotesUseCaseRequest): Promise<SearchNotesUseCaseResponse> {
    const notes = await this.notesRepository.searchMany(query)

    return {
      notes,
    }
  }
}