import type { NotesRepository } from '@/repositories/notes-repository'
import type { Note } from '@prisma/client'

interface FetchNotesUseCaseRequest {
    userId: string
}

interface FetchNotesUseCaseResponse {
  notes: Note[]
}

export class FetchNotesUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    userId
  }: FetchNotesUseCaseRequest): Promise<FetchNotesUseCaseResponse> {
    const notes = await this.notesRepository.findManyByUserId(userId)

    return {
      notes,
    }
  }
}