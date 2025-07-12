import type { NotesRepository } from "@/repositories/notes-repository"
import type { Note } from "@prisma/client"
import { ResourceNotFoundError } from "./errors/resource-not-found-error"
import { InvalidTitleLeghtError } from "./errors/invalid-title-leght-error"
import { InvalidContentLenghtError } from "./errors/invalid-content-leght-error"

interface UpdateNoteUseCaseRequest {
  noteId: string
  title?: string
  content?: string
}

interface UpdateNoteUseCaseResponse {
  note: Note
}

export class UpdateNoteUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    noteId,
    content,
    title
  }: UpdateNoteUseCaseRequest): Promise<UpdateNoteUseCaseResponse> {
    const note = await this.notesRepository.findById(noteId)

    if (!note) {
      throw new ResourceNotFoundError()
    }

    const updateData: Partial<Note> = {}

    if (title !== undefined) {
      if (title.trim().length < 3 || title.trim().length > 30) {
        throw new InvalidTitleLeghtError()
      }
      updateData.title = title
    }

    if (content !== undefined) {
      if (content.trim().length < 10 || content.trim().length > 300) {
        throw new InvalidContentLenghtError()
      }
      updateData.content = content
    }

    if (Object.keys(updateData).length > 0) {
      const updatedNote = await this.notesRepository.save({
        ...note,
        ...updateData
      })
      return { note: updatedNote }
    }

    return { note }
  }
}