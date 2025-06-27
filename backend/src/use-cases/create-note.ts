import type { NotesRepository } from '@/repositories/notes-repository'
import type { Note } from '@prisma/client'

interface CreateNoteUseCaseRequest {
    userId: string
  title: string
  content: string
}

interface CreateNoteUseCaseResponse {
  note: Note
}

export class CreateNoteUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    title,
    content,
    userId
  }: CreateNoteUseCaseRequest): Promise<CreateNoteUseCaseResponse> {
    const note = await this.notesRepository.create({
        title,
        content,
        userId,
    })

    return {
      note,
    }
  }
}