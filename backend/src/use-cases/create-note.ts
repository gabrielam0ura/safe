import type { NotesRepository } from '@/repositories/notes-repository'
import type { Note } from '@prisma/client'
import { InvalidTitleLeghtError } from './errors/invalid-title-leght-error'
import { InvalidContentLenghtError } from './errors/invalid-content-leght-error'

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

    if (!title || title.trim().length < 3 || title.trim().length > 30) {
      throw new InvalidTitleLeghtError()
    }

    if (!content || content.trim().length < 10 || content.trim().length > 300) {
      throw new InvalidContentLenghtError()
    }

    const note = await this.notesRepository.create({
        title: title.trim(),
        content: content.trim(),
        userId,
    })

    return {
      note,
    }
  }
}