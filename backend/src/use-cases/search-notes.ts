import type { NotesRepository } from '@/repositories/notes-repository'
import type { Note } from '@prisma/client'

interface SearchNotesUseCaseRequest {
  query: string
  userId: string
}

interface SearchNotesUseCaseResponse {
  notes: Note[]
}

export class SearchNotesUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    query,
    userId
  }: SearchNotesUseCaseRequest): Promise<SearchNotesUseCaseResponse> {
    const notes = await this.notesRepository.searchMany(query, userId)

    return {
      notes,
    }
  }
}