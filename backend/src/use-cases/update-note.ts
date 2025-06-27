import type { NotesRepository } from "@/repositories/notes-repository"
import type { Note } from "@prisma/client"
import { ResourceNotFoundError } from "./errors/resource-not-found-error"

interface UpdateNoteUseCaseRequest {
  noteId: string
  title?: string
  content?: string
}

interface UpdateNoteUseCaseResponse {
  note: Note
}

export class UpdateTransactionUseCase {
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

    note.title = title ? title : note.title
    note.content = content ? content : note.content

    await this.notesRepository.save(note)

    return { note }
  }
}