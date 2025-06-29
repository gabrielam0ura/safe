import { prisma } from '@/lib/prisma'
import type { Note, Prisma } from '@prisma/client'
import type { NotesRepository } from '../notes-repository'

export class PrismaNotesRepository implements NotesRepository {
  async create(data: Prisma.NoteUncheckedCreateInput){
      const note = await prisma.note.create({
        data
      })
      return note
  }

  async findById(id: string){
      const note = await prisma.note.findUnique({
        where: {
            id
        }
      })
      return note
  }

  async delete(id: string) {
      await prisma.note.delete({
        where:{
            id
        }
    })
  }
  
  async findManyByUserId(userId: string){
      const notes = await prisma.note.findMany({
        where: {
            userId
        }
      })
      return notes
  }

  async searchMany(query: string) {
    const notes = prisma.note.findMany({
      where: {
        title: {
          contains: query,
        },
      },
    })

    return notes
  }

  async searchManyByDate(date: Date){
    const startOfDay = new Date(date)
    startOfDay.setHours(0, 0, 0, 0)
    
    const endOfDay = new Date(date)
    endOfDay.setHours(23, 59, 59, 999)
    const notes = prisma.note.findMany({
        where: {
          createdAt: {
            gte: startOfDay,
            lte: endOfDay,
          }
        },
      })
  
      return notes
  }


  async save(data: Note) {
    const note = await prisma.note.update({
      where: {
        id: data.id,
      },
      data,
    })

    return note
  }

}