import type { Note, Prisma } from "@prisma/client"

export interface NotesRepository {
    findById(id: string): Promise<Note | null>
    create(data: Prisma.UserCreateInput): Promise<Note>
    save(note: Note): Promise<Note>
    findManyByUserId(userId: string): Promise<Number>
    searchMany(query: string): Promise<Note[]>
    searchManyByDate(date: Date): Promise<Note[]>
}