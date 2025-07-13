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
        },
        orderBy: {
          updatedAt: 'desc',
        }
      })
      return notes
  }

  async searchMany(query: string, userId: string) {
    const notes = prisma.note.findMany({
      where: {
        title: {
          contains: query,
        },
        userId,
      },
      orderBy: {
        updatedAt: 'desc',
      }
    })

    return notes
  }

  async searchManyByDate(startDate: Date, endDate: Date, userId: string){
    const notes = prisma.note.findMany({
        where: {
          createdAt: {
            gte: startDate,
            lte: endDate,
          },
          userId,
        },
        orderBy: {
          updatedAt: 'desc',
        }
      })
  
      return notes
  }


  async save(data: Note) {
    const note = await prisma.note.update({
      where: {
        id: data.id,
      },
      data: {
        title: data.title,
        content: data.content,
      },
    })

    return note
  }

}