import type { NotesRepository } from '@/repositories/notes-repository'

interface DeleteNoteUseCaseRequest {
    noteId: string
}

export class DeleteNoteUseCase {
  constructor(private notesRepository: NotesRepository) {}

  async execute({
    noteId
  }: DeleteNoteUseCaseRequest): Promise<void> {
    const note = await this.notesRepository.delete(noteId)
  }
}