import type { Note, Prisma } from '@prisma/client'
import type { NotesRepository } from '../notes-repository'
import { randomUUID } from 'node:crypto'

export class InMemoryNotesRepository implements NotesRepository {
  public items: Note[] = []

  async create(data: Prisma.NoteUncheckedCreateInput){
    const note: Note = {
      id: randomUUID(),
      title: data.title,
      content: data.content,
      userId: data.userId,
      createdAt: new Date(),
      updatedAt: null,
    }

    this.items.push(note)

    return note
  }

  async findManyByUserId(userId: string) {
    return this.items.filter((item) => item.userId === userId)
  }

  async findById(id: string){
    const note = this.items.find((item) => item.id === id)

    if (!note) {
      return null
    }

    return note
  }

  async save(note: Note) {
    const noteIndex = this.items.findIndex((item) => item.id === note.id)

    if (noteIndex >= 0) {
      note.updatedAt = new Date
      this.items[noteIndex] = note
    }

    return note
  }

  async delete(id: string) {
    const noteIndex = this.items.findIndex((item) => item.id === id)

    if (noteIndex !== -1) {
      this.items.splice(noteIndex, 1)
    }
  }

  async searchMany(query: string) {
    return this.items
      .filter((note) => note.title.includes(query))
  }

  async searchManyByDate(date: Date) {
    return this.items
    .filter((note) => note.createdAt === date)
  }
}