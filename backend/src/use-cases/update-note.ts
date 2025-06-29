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
    const note =
      await this.notesRepository.findById(noteId)

    if (!note) {
      throw new ResourceNotFoundError()
    }

    if (title !== undefined) {
      if (title.trim().length < 3 || title.trim().length > 30) {
        throw new InvalidTitleLeghtError()
      }
      note.title = title
    }

    if (content !== undefined) {
      if (content.trim().length < 25 || content.trim().length > 300) {
        throw new InvalidContentLenghtError()
      }
      note.content = content
    }

    note.title = title ? title : note.title
    note.content = content ? content : note.content

    await this.notesRepository.save(note)

    return { note }
  }
}