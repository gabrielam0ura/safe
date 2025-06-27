import type { Note, Prisma } from "@prisma/client"

export interface NotesRepository {
    findById(id: string): Promise<Note | null>
    create(data: Prisma.NoteUncheckedCreateInput): Promise<Note>
    save(note: Note): Promise<Note>
    delete(id: string): Promise<void>
    findManyByUserId(userId: string): Promise<Note[]>
    searchMany(query: string): Promise<Note[]>
    searchManyByDate(date: Date): Promise<Note[]>
}